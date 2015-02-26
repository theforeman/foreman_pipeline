module Integration
  class JobJenkinsProject < Katello::Model
    self.include_root_in_json = false

    belongs_to :job, :inverse_of => :job_jenkins_projects, :class_name => 'Integration::Job'
    belongs_to :jenkins_project, :inverse_of => :job_jenkins_projects, :class_name => 'Integration::JenkinsProject' 

    validate :org_membership

    private 

    def org_memebeship
      unless job.organization == jenkins_project.organization
        errors.add(:base, "Cannot add a project from different organization than #{job.organization.name}")
      end
    end
  end
end