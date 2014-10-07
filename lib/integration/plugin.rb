Foreman::Plugin.register :integration do
  
  sub_menu :top_menu, :integration_menu, :caption => N_('Integration') do
    menu :top_menu,
         :integration,       
         :caption => N_("Integration"),
         :url => '/jobs',
         :url_hash => {:controller => 'integration/api/jobs', :action => 'index'},
         :engine => Integration::Engine       
  end
end
