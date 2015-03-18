module Actions
  module ForemanPipeline
    module Jenkins
      class List < AbstractJenkinsAction
        def run
          output[:projects] = job.jenkins_instance.client.job.list input[:filter]
        end
      end
    end
  end
end