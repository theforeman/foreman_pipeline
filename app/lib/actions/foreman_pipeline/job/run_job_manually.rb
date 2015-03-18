module Actions
  module ForemanPipeline
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job)
          if job.is_valid? && job.target_cv_version_avail? && !job.version_already_promoted?
            plan_action(DeployNewHost, job)            
            plan_self(:info => "Manually triggered job started.")
          else
            plan_self(:info => "Manually triggered job execution skipped, check job configuration.")
          end
        end

        def run
          output = input
        end        
      end
    end
  end
end