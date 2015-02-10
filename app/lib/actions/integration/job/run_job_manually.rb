module Actions
  module Integration
    module Job
      class RunJobManually < Actions::EntryAction
        
        def plan(job, package_names)
          plan_self      
          if job.is_valid? && job.target_cv_version_avail?
            sequence do
              plan_action(Redeploy, job)
              # plan_action(Jenkins::CreateJenkinsMainJob, :job_id => job.id, :unique_name => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com",
              #   :host_ip => "192.168.100.102", :package_names => package_names)
              # test_jobs_names = []

              # job.tests.each do |test|
              #   create_test = plan_action(Jenkins::CreateJenkinsTestJob, :unique_name => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com",
              #    :job_id => job.id, :test_name => test.name)
              #   plan_action(Jenkins::RunJenkinsJob, :job_id => job.id, :name => create_test.output[:name])
              #   plan_action(Jenkins::WaitForBuild, :job_id => job.id, :test_id => test.id, :name => create_test.output[:name])
              #   plan_action(Jenkins::CopyTestFile, :job_id => job.id, :name => create_test.output[:name], :test_id => test.id)
              #   plan_action(Jenkins::ConfigureJenkinsTestJob, :job_id => job.id, :name => create_test.output[:name], :test_name => test.name)
              #   test_jobs_names << create_test.output[:name]
              # end

              # plan_action(Jenkins::AddDownstreamJobs, :job_id => job.id, :names => test_jobs_names,
              #  :upstream_job => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com")
              # plan_action(Jenkins::RunJenkinsJob, :job_id => job.id, :name => "first-job-d5326614-b801-47d9-96ef-3c1d200cc69e.example.com")
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