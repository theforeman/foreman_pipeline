module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job)
          if job.is_valid? && job.target_cv_version_avail? 
            plan_action(DeployNewHost, job)            
            plan_self(:info => "Manually triggeredd job started.")
          else
            plan_self(:info => "Manually triggered job execution skipped, appropriate content view version not available.")
          end
        end

        def run
          output = input
        end        
      end
    end
  end
end