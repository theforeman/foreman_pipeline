module Actions
  module ForemanPipeline
    module Jenkins
      class GetBuildParams < AbstractJenkinsAction
        def run
          output[:build_params] = job.jenkins_instance.client.job.get_build_params input.fetch(:name)
        end
      end
    end
  end
end