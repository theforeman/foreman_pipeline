require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jenkins_project_params do
  permission :edit_jenkins_project_params,
              {
                'foreman_pipeline/api/jenkins_project_params' => [:update],
              },
              :resource_type => 'ForemanPipeline::JenkinsProjectParam'
end