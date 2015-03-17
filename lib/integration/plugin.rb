Foreman::Plugin.register :integration do
  
  sub_menu :top_menu, :integration_menu, :caption => N_('Pipeline') do
    menu :top_menu,
         :jobs,       
         :caption => N_("Jobs"),
         :url => '/jobs',
         :url_hash => {:controller => 'integration/api/jobs', :action => 'index'},
         :engine => Integration::Engine
    menu :top_menu,
         :jenkins_instances,
         :caption => N_("Jenkins Instances"),
         :url => '/jenkins_instances',
         :url_hash => {:controller => 'integration/api/jenkins_instances', :action => 'index'},
         :engine => Integration::Engine
  end
end
