require 'katello/api/mapper_extensions'

class ActionDispatch::Routing::Mapper
  include Katello::Routing::MapperExtensions
end

ForemanPipeline::Engine.routes.draw do
  

  scope :foreman_pipeline, :path => '/foreman_pipeline' do
    
    namespace :api do
    
      api_resources :organizations, :only => [] do  
        api_resources :jobs do
          member do
            put :set_content_view
            put :set_hostgroup
            put :set_resource
            get :available_resources
            put :set_jenkins
            put :set_environment
            get :run_job
            put :add_projects
            put :remove_projects
            put :set_paths
            put :remove_paths
          end
        end

        api_resources :jenkins_instances do
          member do
            get :check_jenkins
            put :set_jenkins_user
          end


        end

        api_resources :jenkins_projects, :only => [:show, :update]

        api_resources :jenkins_requests, :only => [] do
          collection do
            get :list
          end
        end

        api_resources :jenkins_project_params, :only => [:update]

        api_resources :jenkins_users, :only => [:index, :create, :destroy, :show, :update]  
        
      end
    end
  end  
end
