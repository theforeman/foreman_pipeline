module Integration
  class Api::JenkinsInstancesController < Katello::Api::V2::ApiController
    respond_to :json
   
    include Api::Rendering

    before_filter :find_jenkins_instance, :only => []
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
     
   end
 end
end