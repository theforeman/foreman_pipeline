module Actions
  module ForemanPipeline
    module Job
      class MultiplePromotions < Actions::EntryAction
        
        def plan(job, environments)
          sequence do
            environments.each do |env|
              plan_action(::Actions::Katello::ContentView::Promote, job.target_cv_version, env, false)
            end
          end          
        end

      end
    end
  end
end