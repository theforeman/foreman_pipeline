module Actions
  module ForemanPipeline
    module Job
      class JobHook < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def run
          jobs = input[:job_ids].map { |id| ::ForemanPipeline::Job.find id }
          jobs.map do |job|
            ForemanTasks.trigger(DeployNewHost, job)
          end
        end

        def filter
          @filter ||= ::ForemanPipeline::JobFilter.new
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

      end
    end
  end
end