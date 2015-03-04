require 'erb'
module Actions
  module Integration
    module Jenkins
      class BuildProject < AbstractJenkinsAction

        def run
          job.jenkins_instance.client.job.build(jenkins_project.name, params)
          output[:project_name] = jenkins_project.name
          output[:build_params] = params
        end

        def jenkins_project
          ::Integration::JenkinsProject.find(input[:project_id])
        end

        def params
          project_params = job.jenkins_project_params(jenkins_project)
          return {} if project_params.empty?
          template_binding project_params
        end

        def template_binding(project_params)
          host = input[:data][:host]
          activation_key = input[:data][:activation_key]
          packages = input[:packages]
          
          project_params.each do |param|
            param.value = ERB.new(param.value).result(binding)
            param.format_bool
          end.map do |param|
            {param.name => param.value}
          end.reduce(:merge)
        end
      end
    end
  end
end