Foreman::Plugin.register :integration do
  
  sub_menu :top_menu, :integration_menu, :caption => N_('Integration') do
    menu :top_menu,
         :jobs,       
         :caption => N_("Jobs"),
         :url => '/jobs',
         :url_hash => {:controller => 'integration/api/jobs', :action => 'index'},
         :engine => Integration::Engine
    menu :top_menu,
         :tests,
         :caption => N_("Tests"),
         :url => '/tests',
         :url_hash => {:controller => 'integration/api/tests', :action => 'index'},
         :engine => Integration::Engine
  end
end
