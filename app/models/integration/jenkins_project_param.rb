module Integration
  class JenkinsProjectParam < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue

    include Integration::Authorization::JenkinsProjectParam

    self.inheritance_column = :_inheritance_type_disabled
    belongs_to :organization
    belongs_to :job_jenkins_project, :inverse_of => :jenkins_project_params, :class_name => "Integration::JobJenkinsProject"
    has_one :jenkins_project, :through => :job_jenkins_project
    attr_accessible :name, :type, :description, :value

    TYPES = ["string", "boolean"]
    validates :type, :inclusion => { :in => TYPES }
  end
end