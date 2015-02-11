module Actions
  module Integration
    module Jenkins
      class CreateJenkinsJobAndTestsAndRun < Actions::EntryAction

        def plan(job)

          plan_self
          
          sequence do
          plan_action(CreateJenkinsMainJob,
                       :job_id => opts[:job_id], 
                       :unique_name => opts[:unique_name],
                       :host_ip => opts[:host_ip],
                       :package_names => opts[:package_names],
                       :jenkins_instance_hostname => opts[:jenkins_instance_hostname],
                       :jenkins_home => opts[:jenkins_home])
            test_jobs_names = []

            job.tests.each do |test|
              create_test = plan_action(CreateJenkinsTestJob,
                                         :unique_name => opts.fetch(:unique_name),
                                         :job_id => opts.fetch(:job_id),
                                         :test_name => test.name)
              plan_action(RunJenkinsJob,
                           :job_id => opts.fetch(:job_id),
                           :name => create_test.output[:name])
              plan_action(WaitForBuild,
                           :job_id => opts.fetch(:job_id),
                           :test_id => test.id,
                           :name => create_test.output[:name])
              plan_action(CopyTestFile,
                           :job_id => opts.fetch(:job_id),
                           :name => create_test.output[:name],
                           :test_id => test.id,
                           :jenkins_home => opts.fetch(:jenkins_home))
              plan_action(ConfigureJenkinsTestJob,
                           :job_id => opts.fetch(:job_id),
                           :name => create_test.output[:name],
                           :test_name => test.name)

              test_jobs_names << create_test.output[:name]
            end
              plan_action(AddDownstreamJobs, 
                          :job_id => opts.fetch(:job_id), 
                          :names => test_jobs_names,
                          :upstream_job => opts.fetch(:unique_name))
              plan_action(RunJenkinsJob, 
                          :job_id => opts[:job_id],
                          :name => opts[:unique_name])
          end
        end

        def run
          output[:result] = input
        end
      end
    end
  end
end