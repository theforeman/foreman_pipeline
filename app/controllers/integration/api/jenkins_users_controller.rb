module Integration
  class Api::JenkinsUsersController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index]
    before_filter :find_jenkins_user, :only => [:show, :destroy]

    def index
       ids = JenkinsUser.readable
            .where(:organization_id => @organization.id, :jenkins_instance_id => params[:jenkins_instance_id])
            .pluck(:id)

      filters = [:terms => {:id => ids}]       

      options = {
         :filters => filters,
         :load_records? => true
      }
      respond_for_index(:collection => item_search(JenkinsUser, params, options))
    end

    # def show
    #   respond_for_show(:resource => @jenkins_user)
    # end

    def create
      @jenkins_user = JenkinsUser.new(jenkins_user_params)
      @jenkins_user.organization = @organization
      @jenkins_user.save!

      respond_for_show(:resource => @jenkins_user)
    end

    def destroy
      @jenkins_user.destroy
      respond_for_show(:resource => @jenkins_user)
    end


    protected

    def find_jenkins_user
      @jenkins_user = JenkinsUser.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find Jenkins User with id #{params[:id]}" if @jenkins_user.nil?
      @jenkins_user 
    end
    
  end
end