module ForemanPipeline
  class JobToEnvironment < Katello::Model

    belongs_to :job, :inverse_of => :job_to_environments, :class_name => 'ForemanPipeline::Job'
    belongs_to :to_environment, :inverse_of => :job_to_environments, :class_name => 'Katello::KTEnvironment'

    belongs_to :organization
    validate :org_membership

    private

    def org_membership
      unless self.job.organization == self.to_environment.organization
        errors.add(:base, "Cannot add an Environment Path from different organization than #{job.organization.name}")
      end
    end

  end
end