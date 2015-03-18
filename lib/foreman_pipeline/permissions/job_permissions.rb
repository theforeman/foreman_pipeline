require 'foreman_pipeline/plugin'

Foreman::Plugin.find(:foreman_pipeline).security_block :jobs do
  permission :view_jobs,
              {
                'foreman_pipeline/jobs' => [:all, :index, :show],
                'foreman_pipeline/api/jobs' => [:index, :show],
              },
              :resource_type => 'ForemanPipeline::Job'
  permission :create_jobs,
              {
                'foreman_pipeline/api/jobs' => [:create],
              },
              :resource_type => 'ForemanPipeline::Job'
  permission :edit_jobs,
              {
                'foreman_pipeline/api/jobs' => [:update],
              },
              :resource_type => 'ForemanPipeline::Job'
  permission :destroy_jobs,
              {
                'foreman_pipeline/api/jobs' => [:destroy],
              },
              :resource_type => 'ForemanPipeline::Job'
end