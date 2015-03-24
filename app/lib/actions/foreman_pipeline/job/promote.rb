module Actions
  module ForemanPipeline
    module Job
      class Promote < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(opts)
          plan_self(opts)
        end

        def run
          fail "Content View promotion disabled." unless job.promote?
          promote_environment unless target_environment.nil?
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        private

        def promote_environment
          ForemanTasks.trigger(::Actions::Katello::ContentView::Promote, job.target_cv_version, target_environment, false)
          output[:cv_to_promote] = job.content_view.name
          output[:target_environment] = target_environment.name
          output[:in_job] = job.name
        end

        def target_environment
          job.environment.successor
        end

        def job
          j = ::ForemanPipeline::Job.find input.fetch(:job_id)
        end
      end
    end
  end
end