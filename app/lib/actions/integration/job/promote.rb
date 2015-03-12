module Actions
  module Integration
    module Job
      class Promote < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(opts)
          plan_self(opts)
        end

        def run
          promote_env unless target_environment.nil?
        end

        private

        def promote_env
          ForemanTasks.trigger(::Actions::Katello::ContentView::Promote, job.target_cv_version, target_environment, false)
          output[:cv_to_promote] = job.content_view.name
          output[:target_environment] = target_environment.name
          output[:in_job] = job.name
        end

        def target_environment
          job.environment.successor
        end

        def job
          j = ::Integration::Job.find input.fetch(:job_id)
        end
      end
    end
  end
end