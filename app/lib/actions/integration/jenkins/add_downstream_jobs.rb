module Actions
  module Integration
    module Jenkins
      class AddDownstreamJobs < AbstractJenkinsAction
        def run
          job.jenkins_instance.client.job.add_downstream_projects(input.fetch(:upstream_job), input.fetch(:names).join(","), "success")
        end
      end
    end
  end
end