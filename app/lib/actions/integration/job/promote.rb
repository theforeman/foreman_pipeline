module Actions
  module Integration
    module Job
      class Promote < Actions::EntryAction
        
        def plan(hash)
          sequence do
            promote_action = plan_self(hash)
            # plan_action(Dummy, :job_name => hash[:job_name])#, :build_fails => promote_action.output[:build_fails])
          end
        end

        def run
          # binding.pry
          output[:dummy] = "Promote action triggered for Job: #{input[:job_name]}"
          # ForemanTasks.trigger(Dummy, :job_name => input[:job_name])
          ::User.current = ::User.anonymous_admin
          promote_env unless target_environment.nil? || job.target_cv_version.environments.include?(target_environment)
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