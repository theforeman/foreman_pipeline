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
          put :set_resource
          put :remove_tests
          get :available_tests
          put :add_tests
          get :available_resources
          put :set_jenkins
        end
      end

      api_resources :tests

      api_resources :jenkins_instances
      
    end

    end
    

  end  

end
