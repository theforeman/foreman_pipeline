module Actions
  module Integration
    module Jenkins
      class WaitForBuild < WaitAndPoll        
        
        def poll_interval
          10
        end

        private

        def poll_external_task
          details = job.jenkins_instance.client.job
                      .get_build_details(input.fetch(:name), input.fetch(:build_num))
                      .with_indifferent_access
          output[:details] = details
          details[:building] == false
        end

      end
    end
  end
end