require 'erb'
module Actions
  module ForemanPipeline
    module Jenkins
      class Build < AbstractJenkinsAction

        def run
          timeout = job.jenkins_instance.timeout_sec
          output[:project_name] = jenkins_project.name
          output[:build_params] = params
          output[:build_num] = job.jenkins_instance.client.job.build(jenkins_project.name, params, 'build_start_timeout' => timeout)
        rescue => e
          fail "Jenkins build for #{jenkins_project.name} failed to start in a timely manner."
        end

        def params
          project_params = jenkins_project.jenkins_project_params
          return {} if project_params.empty?
          template_binding project_params
        end

        def rescue_strategy_for_self
          Dynflow::Action::Rescue::Skip
        end

        def template_binding(project_params)
          host = input[:data][:host]
          activation_key = input[:data][:activation_key]
          packages = input[:data][:packages]

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
