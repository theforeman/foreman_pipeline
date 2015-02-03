module Actions
  module Integration
    module Job
      class RunJenkinsJob < Actions::EntryAction
        def run
          job = ::Integration::Job.find input[:job_id]
          job.init_run
          job.jenkins_instance.client.job.build(input[:jobname])
        end
      end
    end
  end
end