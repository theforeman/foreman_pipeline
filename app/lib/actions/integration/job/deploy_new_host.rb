module Actions
  module Integration
    module Job
      class DeployNewHost < Actions::EntryAction
        
        def plan(job)          
          sequence do
            redeploy = plan_action(Redeploy, job)

            to_install = plan_action(FindPackagesToInstall, :job_id => job.id)
                
            jenkins = plan_action(Jenkins::CreateJenkinsJobAndTestsAndRun,
                                       job, 
                                       to_install.output[:package_names],
                                       :host => redeploy.output[:host])

            plan_self(:host => redeploy.output[:host],
                      :packages => to_install.output[:package_names])

          end
        end

        def run
          output = input
        end

      end
    end
  end
end