module Actions
  module Integration
    module Jenkins
      class CreateJenkinsTestJob < CreateJenkinsJob
        def run
          test_name = [input[:test_name], input[:unique_name]].join("-")
          create_jenkins_job(input[:job_id], test_name)
          output[:name] = test_name
        end
      end
    end
  end
end