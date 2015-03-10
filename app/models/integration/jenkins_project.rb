module Integration
  class JenkinsProject < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::JenkinsProject
    include Integration::Authorization::JenkinsProject

    belongs_to :organization

    has_many :job_jenkins_projects, :dependent => :destroy
    has_many :jobs, :through => :job_jenkins_projects, :class_name => 'Integration::Job'
  
    has_many :jenkins_project_params, :class_name => 'Integration::JenkinsProjectParam', :dependent => :destroy
    
    accepts_nested_attributes_for :jenkins_project_params
  end
end