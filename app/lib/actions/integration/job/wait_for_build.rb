module Actions
  module Integration
    module Job
      class WaitForBuild < Actions::EntryAction
        include Dynflow::Action::Polling

        def external_task
          output[:result]
        end

        def done?
          external_task
        end

        private

        def invoke_external_task
          nil
        end

        def external_task=(external_task_data)
          output[:result] = external_task_data
        end

        def poll_external_task
          job = ::Integration::Job.find input.fetch(:job_id)
          job.init_run
          job.jenkins_instance.client.job.get_current_build_status(input.fetch(:name)).include? "success" 
        end

        def poll_interval
          5
        end
      end
    end
  end
end