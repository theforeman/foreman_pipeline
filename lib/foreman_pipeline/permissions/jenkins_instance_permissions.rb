require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jenkins_instances do
  permission :view_jenkins_instances,
              {
                'foreman_pipeline/jenkins_instances' => [:all, :index, :show],
                'foreman_pipeline/api/jenkins_instances' => [:index, :show, :check_jenkins],
              },
              :resource_type => 'ForemanPipeline::JenkinsInstance'
  permission :create_jenkins_instances,
              {
                'foreman_pipeline/api/jenkins_instances' => [:create],
              },
              :resource_type => 'ForemanPipeline::JenkinsInstance'
  permission :edit_jenkins_instances,
              {
                'foreman_pipeline/api/jenkins_instances' => [:update, :set_jenkins_user],
              },
              :resource_type => 'ForemanPipeline::JenkinsInstance'
  permission :destroy_jenkins_instances,
              {
                'foreman_pipeline/api/jenkins_instances' => [:destroy],
              },
              :resource_type => 'ForemanPipeline::JenkinsInstance'
end