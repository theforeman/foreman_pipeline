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

              plan_action(Jenkins::CreateJenkinsMainJob,
                       :job_id => job.id, 
                       :unique_name => redeploy.output[:name],
                       :host_ip => redeploy.output[:ip],
                       :package_names => package_names,
                       :jenkins_instance_hostname => URI(job.jenkins_instance.url).host,
                       :jenkins_home => job.jenkins_instance.jenkins_home)
              test_jobs_names = []

              # job.tests.each do |test|
              #   create_test = plan_action(Jenkins::CreateJenkinsTestJob,
              #                              :unique_name => redeploy.output[:name],
              #                              :job_id => job.id,
              #                              :test_name => test.name)
              #   plan_action(Jenkins::RunJenkinsJob,
              #                :job_id => job.id,
              #                :name => create_test.output[:name])
              #   plan_action(Jenkins::WaitForBuild,
              #                :job_id => job.id,
              #                :test_id => test.id,
              #                :name => create_test.output[:name])
              #   plan_action(Jenkins::CopyTestFile,
              #                :job_id => job.id,
              #                :name => create_test.output[:name],
              #                :test_id => test.id,
              #                :jenkins_home => job.jenkins_instance.jenkins_home)
              #   plan_action(Jenkins::ConfigureJenkinsTestJob,
              #                :job_id => job.id,
              #                :name => create_test.output[:name],
              #                :test_name => test.name)

              #   test_jobs_names << create_test.output[:name]
              # end
              #   plan_action(Jenkins::AddDownstreamJobs, 
              #               :job_id => job.id, 
              #               :names => test_jobs_names,
              #               :upstream_job => redeploy.output[:name])
              #   plan_action(Jenkins::RunJenkinsJob, 
              #               :job_id => job.id,
              #               :name => redeploy.output[:name])
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