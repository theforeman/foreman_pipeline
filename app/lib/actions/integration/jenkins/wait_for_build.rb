module Actions
  module Integration
    module Jenkins
      class WaitForBuild < WaitAndPoll        
        
        def poll_interval
          10
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        def run(event = nil)
          unless event == Dynflow::Action::Skip
            super
          end
        end

        def external_task=(external_task_data)
          if external_task_data.is_a?(Hash)
            output[:result] = !external_task_data[:result].nil?
            if external_task_data[:result] == "FAILURE"
              fail "Jenkins build failed"          
            end
          end                    
        end

        private

        def poll_external_task
          details = job.jenkins_instance.client.job
                      .get_build_details(input.fetch(:name), input.fetch(:build_num))
                      .with_indifferent_access
          output[:details] = details
          details
        end

      end
    end
  end
end