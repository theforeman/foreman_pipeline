module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job, package_names)
          plan_self      
          if job.is_valid? && job.target_cv_version_avail?
            sequence do
              # plan_action(Redeploy, job)
              # plan_action(Jenkins::CreateJenkinsMainJob, :job_id => job.id, :unique_name => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com",
              #   :host_ip => "192.168.100.102", :package_names => package_names)
              job.tests.each do |test|
                testjobs_names = []
                create_test = plan_action(Jenkins::CreateJenkinsTestJob, :unique_name => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com",
                 :job_id => job.id, :test_name => test.name)
                plan_action(Jenkins::RunJenkinsJob, :job_id => job.id, :name => create_test.output[:name])
                plan_action(Jenkins::WaitForBuild, :job_id => job.id, :test_id => test.id, :name => create_test.output[:name])
                plan_action(Jenkins::CopyTestFile, :name => create_test.output[:name], :job_id => job.id, :test_id => test.id)
                # plan_action(Jenkins::ConfigureJenkinsJob, :name => create_test.output[:name])
                # testjobs_names << create_test.output[:name]
              end
              # plan_action(AddTestsToMainJob)
              # plan_action(RunJenkinsJob, :job_id => job.id, :jobname => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com")
              # plan_action(Dummy, :job_name => job.name)
            end
          end
        end

        def run
        end        
      end
    end
  end
end