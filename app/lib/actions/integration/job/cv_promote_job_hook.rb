module Actions
  module Integration
    module Job
      class CvPromoteJobHook < Actions::EntryAction

        def self.subscribe
          Katello::ContentView::Promote
        end

        def plan(version, environment, is_force = false)          
          valid_jobs = version.content_view.jobs.select { |job| job.is_valid? }
          jobs_to_run = valid_jobs.select { |job| version.eql? job.target_cv_version }
          allowed_jobs = jobs_to_run.select { |job| job.levelup_trigger && !job.version_already_promoted? }
          
          plan_self(:trigger => trigger.output,
                    :job_ids => allowed_jobs.map(&:id),
                    :job_names => allowed_jobs.map(&:name))    
        end

        def run
          fail "Multiple jobs defined for the same content view and environment: #{input[:job_names]}.
               This may result in unexpected behaviour.
               Resolve the conflict and rerun the task." if input[:job_ids].length > 1
          if input[:job_ids].length == 1
            job = ::Integration::Job.find(input[:job_ids].first)
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