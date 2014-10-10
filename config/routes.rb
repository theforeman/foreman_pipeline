Integration::Engine.routes.draw do
  # match '/home' => 'basic#home', :via => :get

  scope :integration, :path => '/integration' do
    
    namespace :api do
      
      resources :jobs do
        collection do
          get :content_view
          get :hostgroup
        end
      end

    end
    

  end  
  # resources :repositories, :only => [:index]
  

end
