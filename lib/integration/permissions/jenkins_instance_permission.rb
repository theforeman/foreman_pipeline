require 'integration/plugin'

Foreman::Plugin.find(:integration).security_block :jenkins_instances do
  permission :view_jenkins_instances,
              {
                'integration/jenkins_instances' => [:all, :index, :show],
                'integration/api/jenkins_instances' => [:index, :show],
              },
              :resource_type => 'Integration::JenkinsInstance'
  permission :create_jenkins_instances,
              {
                'integration/api/jenkins_instances' => [:create],
              },
              :resource_type => 'Integration::JenkinsInstance'
  permission :edit_jenkins_instances,
              {
                'integration/api/jenkins_instances' => [:update],
              },
              :resource_type => 'Integration::JenkinsInstance'
  permission :destroy_jenkins_instances,
              {
                'integration/api/jenkins_instances' => [:destroy],
              },
              :resource_type => 'Integration::JenkinsInstance'
end