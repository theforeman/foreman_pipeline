module Actions
  module ForemanPipeline
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
            
            # h = { :host => {
            #         :id => "random_number",
            #         :name => "dummy host",
            #         :ip => "192.168.100.103",
            #         :mac => " 01:23:45:67:89:ab",
            #         :params => ["host_params_empty"]
            #       },
            #       :activation_key => {
            #           :cp_id => 544553785444,
            #       },                  
            # }

            packages = plan_action(FindPackagesToInstall, :job_id => job.id)


            bulk_build = plan_action(Jenkins::BulkBuild, 
                                      job.jenkins_projects,
                                      :job_id => job.id,
                                      :data => redeploy.output,
                                      :packages => packages.output[:package_names])
            plan_action(Promote, :job_id => job.id, :build_fails => bulk_build.output[:failed_count])            
          end
        end
      end
    end
  end
end