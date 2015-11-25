module ForemanPipeline
  class JenkinsProject < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::JenkinsProject
    include ForemanPipeline::Authorization::JenkinsProject

    belongs_to :organization

    attr_accessible :name, :organization_id

    has_many :job_jenkins_projects, :dependent => :destroy
    has_many :jobs, :through => :job_jenkins_projects, :class_name => 'ForemanPipeline::Job'

    has_many :jenkins_project_params, :class_name => 'ForemanPipeline::JenkinsProjectParam', :dependent => :destroy

    accepts_nested_attributes_for :jenkins_project_params
  end
end