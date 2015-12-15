module ForemanPipeline
  class JenkinsUser < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include ForemanPipeline::Authorization::JenkinsUser

    belongs_to :organization
    has_many :jenkins_instances, :class_name => "ForemanPipeline::JenkinsInstance", :dependent => :nullify

    validates :name, :presence => true
    validates :token, :presence => true

    attr_accessible :name, :token, :organization_id

    scoped_search :on => :name, :complete_value => true
  end
end
