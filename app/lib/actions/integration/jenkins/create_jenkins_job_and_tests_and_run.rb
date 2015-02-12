require 'uri'
module Actions
  module Integration
    module Jenkins
      class CreateJenkinsJobAndTestsAndRun < Actions::EntryAction
       
        def plan(job, package_names, options = {:host => nil})          
          sequence do
            
            plan_action(CreateJenkinsMainJob,
                       :job_id => job.id, 
                       :unique_name => options[:host][:name],
                       :host_ip => options[:host][:ip],
                       :package_names => package_names,
                       :jenkins_instance_hostname => URI(job.jenkins_instance.url).host,
                       :jenkins_home => job.jenkins_instance.jenkins_home)

            test_jobs_names = []

            concurrence do
              job.tests.each do |test|
                sequence do
                  create_test = plan_action(CreateJenkinsTestJob,
                                             :unique_name => options[:host][:name],
                                             :job_id => job.id,
                                             :test_name => test.name)
                  plan_action(RunJenkinsJob,
                               :job_id => job.id,
                               :name => create_test.output[:name])
                  plan_action(WaitForBuild,
                               :job_id => job.id,
                               :test_id => test.id,
                               :name => create_test.output[:name])
                  plan_action(CopyTestFile,
                               :job_id => job.id,
                               :name => create_test.output[:name],
                               :test_id => test.id,
                               :jenkins_home => job.jenkins_instance.jenkins_home)
                  plan_action(ConfigureJenkinsTestJob,
                               :job_id => job.id,
                               :name => create_test.output[:name],
                               :test_name => test.name)

                  test_jobs_names << create_test.output[:name]
                end
              end
            end
            plan_action(AddDownstreamJobs, 
                        :job_id => job.id, 
                        :names => test_jobs_names,
                        :upstream_job => options[:host][:name])

            
            plan_action(RunJenkinsJob, 
                        :job_id => job.id,
                        :name => options[:host][:name])

            plan_self(:options => options)
          end
        end

        def run
           output[:host] = input[:options][:host]
        end

      end
    end
  end
end