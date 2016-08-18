module ForemanPipeline
  class JenkinsProject < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include ForemanPipeline::Authorization::JenkinsProject

    belongs_to :organization

    validates :name, :presence => true, :uniqueness => true

    belongs_to :job, :class_name => 'ForemanPipeline::Job', :inverse_of => :jenkins_projects
    has_many :jenkins_project_params, :class_name => 'ForemanPipeline::JenkinsProjectParam', :dependent => :destroy

    accepts_nested_attributes_for :jenkins_project_params
  end
end