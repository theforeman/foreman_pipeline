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

          jobs_to_run = valid_jobs.select { |job| job.target_cv_version_avail? }

          jobs_to_run.each do |job|
            if job.sync_trigger
              plan_action(Dummy, :job_name => job.name)                            
            end
          end
        end

        def run
        end    

      end
    end
  end
end