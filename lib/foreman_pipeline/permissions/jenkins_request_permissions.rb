require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jenkins_requests do
  permission :view_jenkins_requests,
              {
                'foreman_pipeline/api/jenkins_requests' => [:list]
              },
              :resource_type => 'ForemanPipeline::JenkinsProject'
end