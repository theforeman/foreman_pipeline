require "test_helper"

FactoryGirl.definition_file_paths << File.join(Katello::Engine.root, 'test', 'factories')
FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.reload

require "#{Katello::Engine.root}/test/support/fixtures_support"
require "fixtures_support"

require 'dynflow/testing'
Mocha::Mock.send :include, Dynflow::Testing::Mimic
require "#{Katello::Engine.root}/test/support/foreman_tasks/task"

module FixtureTestCase
  extend ActiveSupport::Concern

  included do
    extend ActiveRecord::TestFixtures

    self.use_transactional_fixtures = true
    self.use_instantiated_fixtures = false
    self.pre_loaded_fixtures = true

    Katello::FixturesSupport.set_fixture_classes(self)
    ForemanPipeline::FixturesSupport.set_fixture_classes(self)

    self.fixture_path = Dir.mktmpdir("pipeline_and_katello_fixtures")
    FileUtils.cp(Dir.glob("#{Katello::Engine.root}/test/fixtures/models/*"), self.fixture_path)
    FileUtils.cp(Dir.glob("#{ForemanPipeline::Engine.root}/test/fixtures/*"), self.fixture_path)
    FileUtils.cp(Dir.glob("#{Rails.root}/test/fixtures/*"), self.fixture_path)
    fixtures(:all)
    FIXTURES = load_fixtures(ActiveRecord::Base)
  end

  module ClassMethods
    def before_suite
      @@admin = ::User.find(FIXTURES['users']['admin']['id'])
      User.current = @@admin
    end
  end
end

class ActiveSupport::TestCase
  include FixtureTestCase

  def get_organization(org = nil)
    saved_user = User.current
    User.current = User.find(users(:admin).id)
    org = org.nil? ? :empty_organization : org
    organization = Organization.find(taxonomies(org.to_sym).id)
    organization.stubs(:label_not_changed).returns(true)
    organization.setup_label_from_name
    organization.save!
    User.current = saved_user
    organization
  end
end

class ActionController::TestCase
  def setup_engine_routes
    @routes = ForemanPipeline::Engine.routes
  end
end
