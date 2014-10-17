require 'katello/api/mapper_extensions'

class ActionDispatch::Routing::Mapper
  include Katello::Routing::MapperExtensions
end

Integration::Engine.routes.draw do
  

  scope :integration, :path => '/integration' do
    
    namespace :api do
    
    api_resources :organizations, :only => [] do  
      api_resources :jobs do
        collection do
          get :content_view
          get :hostgroup
        end
      end
    end

    end
    

  end  

end
