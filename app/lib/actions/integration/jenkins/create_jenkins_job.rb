module Actions
  module Integration
    module Jenkins
      class CreateJenkinsJob < AbstractJenkinsAction

        def create_jenkins_job(job_id, unique_name, shell_command = "")
          job.jenkins_instance.client.job.create_freestyle(:name => unique_name, :shell_command => shell_command)
        end
        
      end
    end
  end
end