module Actions
  module Integration
    module Jenkins
      class ConfigureJenkinsJob < AbstractJenkinsAction
        
        def run
          job.jenkins_instance.client.job.update_freestyle params_hash
        end

        def params_hash
          {}
        end

      end
    end
  end
end