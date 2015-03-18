module Actions
  module ForemanPipeline
    module Jenkins
      class BuildProject < AbstractJenkinsAction
                
        def plan(options)
          sequence do
            build_task = plan_action(Build, options)
            wait_task = plan_action(WaitForBuild, :job_id => options[:job_id], :name => options[:project_name], :build_num => build_task.output[:build_num])
            
            plan_self(:build_status => wait_task.output[:details][:result], :name => options[:project_name])
          end
        end

        def run
          output[:status] = input[:build_status]
          Dynflow::Action::Rescue::Skip if input[:build_status].match /^FAILURE$/
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        def humanized_name
          "Build Jenkins Project: %s" % input[:name]
        end
      end
    end
  end
end