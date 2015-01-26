module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job)          
          if job.is_valid? && job.target_cv_version_avail?
            plan_action(Dummy)
          end
        end        
      end
    end
  end
end