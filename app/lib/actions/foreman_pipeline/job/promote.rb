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
          promote_environment unless target_environments.empty?
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        private

        def promote_environment
          output[:cv_to_promote] = job.content_view.name
          output[:target_environments] = []
          output[:in_job] = job.name  

          target_environments.each do |env|
            ForemanTasks.trigger(::Actions::Katello::ContentView::Promote, job.target_cv_version, env, false)
            output[:target_environment] << env.name
          end
        end

        def target_environments
          job.environment.successors
        end

        def job
          j = ::ForemanPipeline::Job.find input.fetch(:job_id)
        end
      end
    end
  end
end