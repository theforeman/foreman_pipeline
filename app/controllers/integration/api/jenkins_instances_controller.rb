module Integration
  class Api::JenkinsInstancesController < Katello::Api::V2::ApiController
    respond_to :json
   
    include Api::Rendering

    before_filter :find_jenkins_instance, :only => [:show, :update, :destroy]
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

   protected

   def find_jenkins_instance
     @jenkins_instance = JenkinsInstance.find_by_id(params[:id])
     fail HttpErrors::NotFound "Could noit find Jenkins Instance with id: #{params[:id]}" if @jenkins_instance.nil?
     @jenkins_instance
   end

   def jenkins_instance_params
     params.require(:jenkins_instance).permit(:name, :url)
   end
 end
end