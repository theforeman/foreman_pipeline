Foreman::Plugin.register :integration do
  
  sub_menu :top_menu, :integration_menu, :caption => N_('Integration') do
    menu :top_menu,
         :integration,       
         :caption => N_("Integration"),
         :url => '/abcde/repos',
         :url_hash => {:controller => 'integration/api/repositories', :action => 'index'},
         :engine => Integration::Engine       
  end
end
