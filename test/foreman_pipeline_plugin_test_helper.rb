require 'test_helper'

def katello_root
  "#{ForemanPipeline::Engine::Railties.engines
    .select {|engine| engine.railtie_name == "katello"}
    .first.config.root}"  
end

# requiring Katello's helper does not work, it requires more files that cannot be reached
# require "#{katello_root}/test/katello_test_helper"

require "#{katello_root}/spec/models/model_spec_helper"

class ActiveSupport::TestCase

  def get_organization(org = nil)
    saved_user = User.current
    User.current = User.find(users(:admin))
    org = org.nil? ? :empty_organization : org
    organization = Organization.find(taxonomies(org.to_sym))
    organization.stubs(:label_not_changed).returns(true)
    organization.setup_label_from_name
    organization.save!
    User.current = saved_user
    organization
  end
  
end
