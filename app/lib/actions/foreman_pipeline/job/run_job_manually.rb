module Actions
  module ForemanPipeline
    module Job
      class RunJobManually < Actions::EntryAction

        def plan(job)
          if job.is_valid? && job.target_cv_version_avail? && job.not_yet_promoted?
            plan_action(DeployNewHost, job)
            plan_self(:info => "Manually triggered job started.", :name => job.name)
          else
            plan_self(:info => "Manually triggered job execution skipped, check job configuration.", :name => job.name, :fail => true)
          end
        end

        def run
          output = input
          fail input[:info] if input[:fail]
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        def humanized_name
          "Run manually ForemanPipeline::Job: #{input[:name]}"
        end
      end
    end
  end
end