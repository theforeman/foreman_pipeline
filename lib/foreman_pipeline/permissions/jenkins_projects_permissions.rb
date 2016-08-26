require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jenkins_projects do
  permission :view_jenkins_projects,
              {
                'foreman_pipeline/api/jenkins_projects' => [:show]
              },
              :resource_type => 'ForemanPipeline::JenkinsProject'
end