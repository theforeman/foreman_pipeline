module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job, package_names)
          plan_self      
          if job.is_valid? && job.target_cv_version_avail?
            # plan_action(Redeploy, job)
            # plan_action(PushContent, :unique_name => job.name, :job_id => job.id, :package_names => package_names)
            plan_action(Dummy, :job_name => job.name)
          end
        end

        def run
        end        
      end
    end
  end
end