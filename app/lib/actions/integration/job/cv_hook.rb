module Actions
  module Integration
    module Job
      class CvHook < Actions::EntryAction
        
        def run
          fail "Multiple jobs defined for the same content view and environment: #{input[:job_names]}.
               This may result in unexpected behaviour.
               Resolve the conflict to avoid skipping this action." if input[:job_ids].length > 1
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