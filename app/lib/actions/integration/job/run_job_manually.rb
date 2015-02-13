require 'uri'
module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job, package_names)
          plan_self      
          if job.is_valid? && job.target_cv_version_avail?
            sequence do

              redeploy = plan_action(Redeploy, job)
              # h = {:name => "first-job-62308b27-0323-470e-a284-ecd298e02058.example.com",
              #      :ip => "192.168.100.110"
              #       }
              plan_action(Jenkins::CreateJenkinsJobAndTestsAndRun, job, package_names, :host => redeploy.output[:host])

            end
          end
        end

        def run
        end        
      end
    end
  end
end