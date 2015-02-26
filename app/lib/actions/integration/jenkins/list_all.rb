module Actions
  module Integration
    module Jenkins
      class ListAll < AbstractJenkinsAction
        def run
          output[:projects] = job.jenkins_instance.client.job.list
        end
      end
    end
  end
end