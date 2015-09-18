module Actions
  module ForemanPipeline
    module Job
      class JobHook < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def run
          fail "Multiple jobs defined for the same content view and environment: #{input[:job_names]}.
               This may result in an unexpected behaviour.
               Resolve the conflict to avoid skipping this action." if input[:job_names].length > 1
          jobs = input[:job_ids].map { |id| ::ForemanPipeline::Job.find id }
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