module Actions
  module Integration
    module Jenkins
      class RunJenkinsJob < AbstractJenkinsAction
        def run
          job.jenkins_instance.client.job.build(input[:name], params)
        end

        def params
          {"first_param" => "snake", "second_param" => "violin", "amirite?" => "false"}
        end
      end
    end
  end
end