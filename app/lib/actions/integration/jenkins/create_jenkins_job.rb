module Actions
  module Integration
    module Jenkins
      class CreateJenkinsJob < Actions::EntryAction

        def create_jenkins_job(job_id, unique_name, shell_command = "")
          job = get_job
          job.init_run
          job.jenkins_instance.client.job.create_freestyle(:name => unique_name, :shell_command => shell_command)
        end

        def get_job
          job = ::Integration::Job.find input[:job_id]
        end
      end
    end
  end
end