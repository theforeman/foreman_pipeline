module Actions
  module Integration
    module Jenkins
      class BuildProject < AbstractJenkinsAction
        include ::Dynflow::Action::Cancellable
        
        def plan(options)
          sequence do
            build_task = plan_action(Build, options)
            plan_action(WaitForBuild, :job_id => options[:job_id], :name => options[:project_name], :build_num => build_task.output[:build_num])
            build_details = plan_action(GetBuildDetails, :job_id => options[:job_id],
                                                         :name => options[:project_name],
                                                         :build_num => build_task.output[:build_num])

            # build_status = plan_action(GetCurrentBuildStatus, :job_id => options[:job_id], :name => options[:project_name])
            plan_self(:build_status => build_details.output[:details][:result])
          end
        end

        def run
          output[:status] = input[:build_status]
        #   fail "build failed" if output[:status] != "success"
        end
      end
    end
  end
end