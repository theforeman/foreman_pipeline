Foreman::Plugin.register :integration do
  
  sub_menu :top_menu, :integration_menu, :caption => N_('Integration') do
    menu :top_menu,
         :integration,       
         :caption => N_("Integration"),
         :url_hash => {:controller => 'integration/basic', :action => 'home'},
         :engine => Integration::Engine       
  end
end
