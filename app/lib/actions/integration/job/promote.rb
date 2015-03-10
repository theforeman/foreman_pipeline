module Actions
  module Integration
    module Job
      class Promote < Actions::EntryAction
        
        def plan(opts)
          plan_self(opts)
        end

        def run
          ::User.current = ::User.anonymous_admin
          promote_env unless target_environment.nil?
        end

        private

        def promote_env
          ForemanTasks.trigger(::Actions::Katello::ContentView::Promote, job.target_cv_version, target_environment, false)          
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