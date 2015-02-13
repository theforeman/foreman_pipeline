require 'uri'
module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job, package_names)
          plan_self      
          if job.is_valid? && job.target_cv_version_avail?
            sequence do

              # redeploy = plan_action(Redeploy, job)
              h = {:name => "first-job-38347c26-230e-4675-aa23-08c840a4ba41.example.com",
                   :ip => "192.168.100.101"
                    }
              plan_action(Jenkins::CreateJenkinsJobAndTestsAndRun, job, package_names, :host => h)#redeploy.output[:host])

            end
          end
        end

        def run
        end        
      end
    end
  end
end