require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jenkins_users do
  permission :view_jenkins_users,
              {
                'foreman_pipeline/api/jenkins_users' => [:index, :show]
              },
              :resource_type => 'ForemanPipeline::JenkinsUser'
  permission :create_jenkins_users,
              {
                'foreman_pipeline/api/jenkins_users' => [:create]
              },
              :resource_type => 'ForemanPipeline::JenkinsUser'
  permission :edit_jenkins_users,
              {
                'foreman_pipeline/api/jenkins_users' => [:update]
              },
              :resource_type => 'ForemanPipeline::JenkinsUser'
  permission :destroy_jenkins_users,
              {
                'foreman_pipeline/api/jenkins_users' => [:destroy]
              },
              :resource_type => 'ForemanPipeline::JenkinsUser'
end