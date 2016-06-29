module Actions
  module ForemanPipeline
    module Jenkins
      class BulkBuild < Actions::ActionWithSubPlans

        def plan(projects, opts)
          plan_self(:project_ids => projects.map(&:id), :opts => opts)
        end

        def create_sub_plans
          projects = ::ForemanPipeline::JenkinsProject.where(:id => input[:project_ids])

          packs = input[:opts].delete(:packages)
          input[:opts][:data].merge!({:packages => packs})

          projects.map do |project|
            trigger(BuildProject, input[:opts].merge({:project_id => project.id, :project_name => project.name}))
          end
        end

        def check_for_errors!
          # Do nothing. Just wait for all builds to finish and gather results
        end
      end
    end
  end
end