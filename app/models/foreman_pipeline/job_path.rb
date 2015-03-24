module ForemanPipeline
  class JobPath < Katello::Model

    belongs_to :job, :inverse_of => :job_paths, :class_name => 'ForemanPipeline::Job'
    belongs_to :path, :inverse_of => :job_paths, :class_name => 'Katello::KTEnvrionment'

    belongs_to :organization
    validate :org_membership

    private 

    def org_membership
      unless self.job.organization == self.path.organization
        errors.add(:base, "Cannot add an Environment Path from different organization than #{job.organization.name}")
      end
    end
    
  end
end