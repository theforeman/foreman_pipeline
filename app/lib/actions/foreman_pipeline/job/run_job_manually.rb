module Actions
  module ForemanPipeline
    module Job
      class RunJobManually < Actions::EntryAction

        def plan(job)
          plan_action(DeployNewHost, job)
          plan_self(:info => "Manually triggered job started.", :name => job.name)
        end

        def run
          output = input
        end

        def humanized_name
          "Run manually ForemanPipeline::Job: #{input[:name]}"
        end
      end
    end
  end
end