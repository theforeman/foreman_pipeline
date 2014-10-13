require 'integration/plugin'

Foreman::Plugin.find(:integration).security_block :jobs do
  permission :view_jobs,
              {
                'integration/jobs' => [:all, :index, :show],
                'integration/api/jobs' => [:index, :show],
              },
              :resource_type => 'Integration::Job'
  permission :create_jobs,
              {
                'integration/api/jobs' => [:create],
              },
              :resource_type => 'Integration::Job'
  permission :edit_jobs,
              {
                'integration/api/jobs' => [:update],
              },
              :resource_type => 'Integration::Job'
  permission :destroy_jobs,
              {
                'integration/api/jobs' => [:destroy],
              },
              :resource_type => 'Integration::Job'
end