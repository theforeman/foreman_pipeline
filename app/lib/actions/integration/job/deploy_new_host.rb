module Actions
  module Integration
    module Job
      class DeployNewHost < Actions::EntryAction
        include Mixins::UriExtension
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(job)          
          sequence do
            redeploy = plan_action(Redeploy, job)    

            plan_action(Jenkins::WaitHostReady, :host_ip => redeploy.output[:host][:ip],
                                                :jenkins_instance_hostname => jenkins_hostname(job),
                                                :jenkins_home => job.jenkins_instance.jenkins_home,
                                                :cert_path => job.jenkins_instance.cert_path)
            
            plan_action(JenkinsInstance::Keyscan, :cert_path => job.jenkins_instance.cert_path,
                                                  :jenkins_url => job.jenkins_instance.url,
                                                  :jenkins_home => job.jenkins_instance.jenkins_home,
                                                  :host_ip => redeploy.output[:host][:ip])            

            packages = plan_action(FindPackagesToInstall, :job_id => job.id)
            bulk_build = plan_action(Jenkins::BulkBuild, 
                                      job.jenkins_projects,
                                      :job_id => job.id,
                                      :data => {:packages => packages.output[:package_names]}.merge(redeploy.output))
            plan_action(Promote, :job_id => job.id, :build_fails => bulk_build.output[:failed_count])
            
          end
        end
      end
    end
  end
end