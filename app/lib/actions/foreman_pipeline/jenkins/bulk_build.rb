module Actions
  module ForemanPipeline
    module Jenkins
      class BulkBuild < Actions::ActionWithSubPlans

        def plan(projects, opts)
          plan_self(:project_ids => projects.map(&:id), :opts => opts)
        end

        def create_sub_plans
          projects = ::ForemanPipeline::JenkinsProject.where(:id => input[:project_ids])

          projects.map do |project|
            trigger(BuildProject, input[:opts].merge({:project_id => project.id, :project_name => project.name}))  
          end
        end
        
      end
    end
  end
end