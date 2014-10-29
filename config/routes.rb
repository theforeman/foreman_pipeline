require 'katello/api/mapper_extensions'

class ActionDispatch::Routing::Mapper
  include Katello::Routing::MapperExtensions
end

Integration::Engine.routes.draw do
  

  scope :integration, :path => '/integration' do
    
    namespace :api do
    
    api_resources :organizations, :only => [] do  
      api_resources :jobs do
        member do
          put :set_content_view
          put :set_hostgroup
        end
      end

      api_resources :tests
    end

    end
    

  end  

end
