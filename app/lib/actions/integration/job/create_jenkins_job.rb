module Actions
  module Integration
    module Job
      class CreateJenkinsJob < Actions::EntryAction
        # TODO: supply host.ip, host.name as input params
        def create_jenkins_job(job_id, host_id, shell_command = "")
          job = get_job
          host = get_host
          job.init_run
          job.jenkins_instance.client.job.create_freestyle(:name => get_host.name, :shell_command => shell_command)
        end

        def get_job
          job = ::Integration::Job.find input[:job_id]
        end

        def get_host
          host = ::Host::Managed.find input[:host_id]          
        end

      end
    end
  end
end