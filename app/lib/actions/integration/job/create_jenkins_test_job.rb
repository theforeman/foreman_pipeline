module Actions
  module Integration
    module Job
      class CreateJenkinsTestJob < CreateJenkinsJob
        def run
          create_jenkins_job(input[:job_id], input[:unique_name])
        end
      end
    end
  end
end