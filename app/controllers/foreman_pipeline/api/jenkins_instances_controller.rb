module ForemanPipeline
  class Api::JenkinsInstancesController < Katello::Api::V2::ApiController
    respond_to :json
   
    include Api::Rendering

    before_filter :find_jenkins_instance, :only => [:show, :update, :destroy, :check_jenkins, :set_jenkins_user]
    before_filter :find_organization, :only => [:index, :create]
    before_filter :load_search_service, :only => [:index]

    def_param_group :jenkins_instance do
      param :name, String, :desc => N_("Jenkins instance's name")
      param :url, String, :desc => N_("Jenkins instance's url")
      param :cert_path, String, :desc => ("Path to the private certificate for passwordless access to jenkins server")
      param :jenkins_home, String, :desc => ("Location of $JENKINS_HOME")
    end

    def_param_group :jenkins_instance_id do
      param :organization_id, :number, :desc => N_("Organization identifier"), :required => true
      param :id, :number, :desc => N_("Jenkins instance identifier"), :required => true
    end

    api :GET, "/organizations/:organization_id/jenkins_instances", N_("List jenkins instances")
    param :organization_id, :number, :desc => N_("organization identifier"), :required => true
    param :name, String, :desc => N_("Name of the jenkins instance")  
    def index
      ids = JenkinsInstance.readable.where(:organization_id => @organization.id).pluck(:id)
      filters = [:terms => {:id => ids}]
      filters << {:term => {:name => params[:name]}} if params[:name]

      options = {
        :filters => filters,
        :load_records? => true
      }

      respond_for_index(:collection => item_search(JenkinsInstance, params, options))
    end

    api :POST, "/organizations/:organization_id/jenkins_instances/:id", N_("Create jenkins instance")
    param_group :jenkins_instance_id
    param_group :jenkins_instance
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

    api :PUT, "/organizations/:organization_id/jenkins_instances/:id", N_("Update jenkins instance")
    param_group :jenkins_instance_id
    param_group :jenkins_instance
    def update
      @jenkins_instance.update_attributes!(jenkins_instance_params.except(:url).except(:jenkins_home))
      @jenkins_instance.save!

      respond_for_show(:resource => @jenkins_instance)
    end

    api :GET, "/organizations/:organization_id/jenkins_instances/:id", N_("Get jenkins_instance by identifier")
    param_group :jenkins_instance_id
    def show
      respond_for_show(:resource => @jenkins_instance)
    end

    api :DELETE, "/organizations/:organization_id/jenkins_instances/:id", N_("Delete jenkins_instance")
    param_group :jenkins_instance_id
    def destroy
      @jenkins_instance.destroy
      respond_for_show(:resource => @jenkins_instance)
    end

    api :GET,  "/organizations/:organization_id/jenkins_instances/:id/check_jenkins", N_("Check jenkins instance reachability")
    param_group :jenkins_instance_id
    def check_jenkins
      task = sync_task(::Actions::ForemanPipeline::Jenkins::GetVersion,
                         :id => @jenkins_instance.id, 
                         :name => @jenkins_instance.name)
      @jenkins_instance.server_version = task.output[:version]
      respond_for_show
    end

    api :PUT,  "/organizations/:organization_id/jenkins_instances/:id", N_("Set jenkins user")
    param_group :jenkins_instance_id
    param :jenkins_user_id, :number, :desc => N_("Jenkins user identifier to be set")
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