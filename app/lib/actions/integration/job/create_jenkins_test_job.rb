module Actions
  module Integration
    module Job
      class CreateJenkinsTestJob < CreateJenkinsJob
        def run
          testname = [input[:test_name], input[:unique_name]].join("-")
          create_jenkins_job(input[:job_id], testname)
          output[:name] = testname
        end
      end
    end
  end
end