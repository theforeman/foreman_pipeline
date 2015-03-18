module Actions
  module ForemanPipeline
    module Jenkins
      class WaitAndPoll < AbstractJenkinsAction
        include Dynflow::Action::Polling
        include Dynflow::Action::Cancellable
        
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

        def poll_interval
          5
        end
        
      end
    end
  end
end