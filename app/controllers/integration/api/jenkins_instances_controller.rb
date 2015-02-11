module Integration
  class Api::JenkinsInstancesController < Katello::Api::V2::ApiController
    respond_to :json
   
    include Api::Rendering

    before_filter :find_jenkins_instance, :only => [:show, :update, :destroy, :check_jenkins]
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
     @jenkins_instance.save!
     task = sync_task(::Actions::Integration::JenkinsInstance::CreateJenkinsInstanceKeys, 
                      :url => jenkins_instance_params[:url],
                      :passwd => params[:passwd],
                      :jenkins_home => jenkins_instance_params[:jenkins_home])

     @jenkins_instance.pubkey = task.output.fetch(:pubkey)
     @jenkins_instance.save!
     respond_for_show(:resource => @jenkins_instance)
   end

   def update
     @jenkins_instance.update_attributes!(jenkins_instance_params)
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
     data = @jenkins_instance.check_jenkins_server
     @jenkins_instance.server_version = data
     respond_for_show
   end

   protected

   def find_jenkins_instance
     @jenkins_instance = JenkinsInstance.find_by_id(params[:id])
     fail HttpErrors::NotFound, "Could not find Jenkins Instance with id: #{params[:id]}" if @jenkins_instance.nil?
     @jenkins_instance
   end

   def jenkins_instance_params
     params.require(:jenkins_instance).permit(:name, :url, :jenkins_home)
   end

 end
end