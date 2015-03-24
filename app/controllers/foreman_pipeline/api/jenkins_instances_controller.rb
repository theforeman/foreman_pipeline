module ForemanPipeline
  class Api::JenkinsInstancesController < Katello::Api::V2::ApiController
    respond_to :json
   
    include Api::Rendering

    before_filter :find_jenkins_instance, :only => [:show, :update, :destroy, :check_jenkins, :set_jenkins_user]
    before_filter :find_organization, :only => [:index, :create]
    before_filter :load_search_service, :only => [:index]

    def index
      ids = JenkinsInstance.readable.where(:organization_id => @organization.id).pluck(:id)
      filters = [:terms => {:id => ids}]

      options = {
        :filters => filters,
        :load_records? => true
      }

      respond_for_index(:collection => item_search(JenkinsInstance, params, options))
    end

    def create
      @jenkins_instance = JenkinsInstance.new(jenkins_instance_params)
      @jenkins_instance.organization = @organization          

      rollback = false
      JenkinsInstance.transaction do
        @jenkins_instance.save!
        task = sync_task(::Actions::ForemanPipeline::JenkinsInstance::CreateJenkinsInstanceKeys, 
                      :jenkins_url => jenkins_instance_params[:url],
                      :cert_path => @jenkins_instance.cert_path,
                      :jenkins_home => jenkins_instance_params[:jenkins_home])

        @jenkins_instance.pubkey = task.output.fetch(:pubkey)
        @jenkins_instance.save!

        if task.output.fetch(:status) == 1 
          raise ActiveRecord::Rollback
          rollback = true
        end
      end       
      
      if rollback
        fail ::Katello::HttpErrors::Conflict, "Could not access Jenkins server, are you sure you set up certificates?"         
      else
        respond_for_show(:resource => @jenkins_instance)          
      end     
    end

    def update
      @jenkins_instance.update_attributes!(jenkins_instance_params.except(:url).except(:jenkins_home))
      @jenkins_instance.save!

      respond_for_show(:resource => @jenkins_instance)
    end

    def show
      respond_for_show(:resource => @jenkins_instance)
    end

    def destroy
      @jenkins_instance.destroy
      respond_for_show(:resource => @jenkins_instance)
    end

    def check_jenkins
      task = sync_task(::Actions::ForemanPipeline::Jenkins::GetVersion,
                         :id => @jenkins_instance.id, 
                         :name => @jenkins_instance.name)
      @jenkins_instance.server_version = task.output[:version]
      respond_for_show
    end

    def set_jenkins_user
      @jenkins_instance.jenkins_user = JenkinsUser.find(params[:jenkins_user_id])
      @jenkins_instance.save!
      respond_for_show
    end

    protected

    def find_jenkins_instance
      @jenkins_instance = JenkinsInstance.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find Jenkins Instance with id: #{params[:id]}" if @jenkins_instance.nil?
      @jenkins_instance
    end

    def jenkins_instance_params
      params.require(:jenkins_instance).permit(:name, :url, :jenkins_home, :cert_path)
    end
  end
end