module Actions
  module Integration
    module Jenkins
      class RunJenkinsJob < Actions::EntryAction
        def run
          job = ::Integration::Job.find input[:job_id]
          job.init_run
          job.jenkins_instance.client.job.build(input[:name])
        end
      end
    end
  end
end