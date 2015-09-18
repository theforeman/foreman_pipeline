module Actions
  module ForemanPipeline
    module Job
      class DeployNewHost < Actions::EntryAction
        include Mixins::UriExtension
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(job)
          sequence do
            # redeploy = plan_action(Redeploy, job)

            data = {
              :host => {
                :id => "fake_id",
                :name => "fake-name.example.com",
                :ip => "192.168.100.236"
                },
              :activation_key => {
                :cp_id => "asdfasdf"
              }
            }


            packages = plan_action(FindPackagesToInstall, :job_id => job.id)

            bulk_build = plan_action(Jenkins::BulkBuild,
                                      job.jenkins_projects,
                                      :job_id => job.id,
                                      :data => data,#redeploy.output,
                                      :packages => packages.output[:package_names])
            plan_action(Promote, :job_id => job.id, :build_fails => bulk_build.output[:failed_count])
          end
        end
      end
    end
  end
end