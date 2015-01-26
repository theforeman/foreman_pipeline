module Actions
  module Integration
    module Job
      class RepoSyncJobHook < Actions::EntryAction
        
        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo)
          plan_self(:trigger => trigger.output)
          valid_jobs = repo.jobs.select { |job| job.is_valid? }
          #TODO 
        end      

      end
    end
  end
end