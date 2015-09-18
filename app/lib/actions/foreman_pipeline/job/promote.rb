module Actions
  module ForemanPipeline
    module Job
      class Promote < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(opts)
          plan_self(opts)
        end

        def run
          unless job.environment.successors.empty?
            fail "Content View promotion disabled" if job.to_environments.empty?
            promote_environment
          end
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        private

        def promote_environment
          output[:cv_to_promote] = job.content_view.name
          output[:target_environments] = job.to_environments.pluck(:name)
          output[:in_job] = job.name

          ForemanTasks.trigger(Job::MultiplePromotions, job)
        end

        def job
          j = ::ForemanPipeline::Job.find input.fetch(:job_id)
        end
      end
    end
  end
end