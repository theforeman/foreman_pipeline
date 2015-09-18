module ForemanPipeline
  class JobJenkinsProject < Katello::Model
    self.include_root_in_json = false

    belongs_to :job, :inverse_of => :job_jenkins_projects, :class_name => 'ForemanPipeline::Job'
    belongs_to :jenkins_project, :inverse_of => :job_jenkins_projects, :class_name => 'ForemanPipeline::JenkinsProject'
    belongs_to :organization
    validate :org_membership

    after_destroy :remove_orphaned_projects

    private

    def org_membership
      unless self.job.organization == self.jenkins_project.organization
        errors.add(:base, "Cannot add a project from different organization than #{job.organization.name}")
      end
    end

    def remove_orphaned_projects
      JenkinsProject.find(:all).map { |p| p.destroy if p.jobs.empty? }
    end

  end
end