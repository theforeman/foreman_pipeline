module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job)
          if job.is_valid? && job.target_cv_version_avail? 
            # plan_action(DeployNewHost, job)
            h = {
                    :id => "random_number",
                    :name => "dummy host",
                    :ip => "0.0.0.1",
                    :mac => "no_mac_here",
                    :params => ["host_params_empty"]
                  
            }
            # plan_action(JenkinsInstance::Keyscan)
            concurrence do
              job.jenkins_projects.each do |project|
                plan_action(Jenkins::BuildProject, :job_id => job.id, :project_id => project.id, :host => h)
              end
            end

            plan_self(:info => "Manually triggeredd job was executed")
          else
            plan_self(:info => "Manually triggered job execution skipped, appropriate content view version not available.")
          end
        end

        def run
          output = input
        end        
      end
    end
  end
end