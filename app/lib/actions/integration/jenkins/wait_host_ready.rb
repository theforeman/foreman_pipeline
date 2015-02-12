module Actions
  module Integration
    module Jenkins
      class WaitHostReady < JenkinsInstance::JenkinsInstanceRemoteAction
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

        def poll
          
        end

        def poll_interval
          5
        end
      end
    end
  end
end