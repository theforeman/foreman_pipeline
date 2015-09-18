module Actions
  module ForemanPipeline
    module Job
      class MultiplePromotions < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(job)
          sequence do
            job.to_environments.each do |env|
              plan_action(::Actions::Katello::ContentView::Promote, job.target_cv_version, env, false)
            end
          end
        end

      end
    end
  end
end