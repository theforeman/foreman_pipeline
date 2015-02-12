module Actions
  module Integration
    module Jenkins
      class WaitForBuild < WaitAndPoll
        
        private        
        def poll_external_task
          job.jenkins_instance.client.job.get_current_build_status(input.fetch(:name)).include? "success" 
        end

      end
    end
  end
end