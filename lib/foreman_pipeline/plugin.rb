Foreman::Plugin.register :foreman_pipeline do
  requires_foreman '>= 1.11'

  sub_menu :top_menu, :foreman_pipeline_menu, :caption => N_('Pipeline') do
    menu :top_menu,
         :jobs,
         :caption => N_("Jobs"),
         :url => '/jobs',
         :url_hash => {:controller => 'foreman_pipeline/api/jobs', :action => 'index'},
         :engine => ForemanPipeline::Engine,
         :turbolinks => false
    menu :top_menu,
         :jenkins_instances,
         :caption => N_("Jenkins Instances"),
         :url => '/jenkins_instances',
         :url_hash => {:controller => 'foreman_pipeline/api/jenkins_instances', :action => 'index'},
         :engine => ForemanPipeline::Engine,
         :turbolinks => false
  end
end
