module Actions
  module Integration
    module Jenkins
      class GetBuildDetails < AbstractJenkinsAction
        def run
          output[:details] = job.jenkins_instance.client.job.get_build_details input[:name], input[:build_num]
        end
      end
    end
  end
end