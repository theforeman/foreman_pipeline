module Actions
  module Integration
    module Job
      class RepoSyncJobHook < Actions::EntryAction
        
        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo)
          valid_jobs = repo.jobs.select { |job| job.is_valid? }
          
          jobs_to_run = valid_jobs.select { |job| job.target_cv_version_avail? }
          allowed_jobs = jobs_to_run.select { |job| job.sync_trigger && !job.version_already_promoted? }
          grouped_jobs = allowed_jobs.group_by(&:target_cv_version).values
          # binding.pry
          if grouped_jobs.max_by(&:length).length > 1
            grouped_jobs = grouped_jobs.max_by(&:length)

            plan_self(:trigger => trigger.output,
                      :skip => true,
                      :job_names => grouped_jobs.map(&:name))
          else
            grouped_jobs.flatten!

            plan_self(:trigger => trigger.output,
                      :skip => false,
                      :job_ids => grouped_jobs.map(&:id))            
          end        
        end

        def run
          fail "Multiple jobs defined for the same content view and environment: #{input[:job_names]}.
               This may result in an unexpected behaviour.
               Resolve the conflict to avoid skipping this action." if input[:skip]
          jobs = input[:job_ids].map { |id| ::Integration::Job.find id }
          jobs.map do |job|
            ForemanTasks.trigger(DeployNewHost, job)
          end
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end
    

      end
    end
  end
end