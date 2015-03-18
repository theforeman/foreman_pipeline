module ForemanPipeline
  class JenkinsUser < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::JenkinsUser
    include ForemanPipeline::Authorization::JenkinsUser

    has_many :jobs, :class_name => "ForemanPipeline::Job", :dependent => :nullify
    belongs_to :organization
    belongs_to :jenkins_instance, :class_name => "ForemanPipeline::JenkinsInstance"
    belongs_to :owner, :class_name => "::User"    

    validates :name, :presence => true
    validates :token, :presence => true
    validates :jenkins_instance_id, :presence => true
    validates :owner_id, :presence => true
  end
end