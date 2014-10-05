Integration::Engine.routes.draw do
  # match '/home' => 'basic#home', :via => :get

  scope :integration, :path => '/integration' do
    
    resources :job do
      collection do
        get :content_view
        get :hostgroup
      end
    end

  end  
  # resources :repositories, :only => [:index]
  

end
