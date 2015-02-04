module Actions
  module Integration
    module Jenkins
      class RunJenkinsJob < AbstractJenkinsAction
        def run
          job.jenkins_instance.client.job.build(input[:name])
        end
      end
    end
  end
end