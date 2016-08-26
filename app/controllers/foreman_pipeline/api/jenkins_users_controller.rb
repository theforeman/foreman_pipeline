module ForemanPipeline
  class Api::JenkinsUsersController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering
    include Concerns::ApiControllerExtensions

    before_action :find_organization, :only => [:create, :index]
    before_action :find_jenkins_user, :only => [:show, :destroy, :update]

    def_param_group :jenkins_user_id do
      param :organization_id, :number, :desc => N_("organization identifier"), :required => true
      param :id, :number, :desc => N_("Jenkins user identifier"), :required => true
    end

    def_param_group :jenkins_user do
      param :name, String, :desc => N_("Jenkins user name")
      param :token, String, :desc => N_("Jenkins user token")
    end

    api :GET, "/organizations/:organization_id/jenkins_users", N_("List jenkins users")
    param :organization_id, :number, :desc => N_("organization identifier"), :required => true
    param :name, String, :desc => N_("Name of the jenkins instance")
    def index
      respond_for_index(:collection => scoped_search(index_relation.uniq, params[:sort_by], params[:sort_order]))
    end

    def index_relation
      query = JenkinsUser.where(:organization_id => @organization.id)
      query = query.where(:name => params[:name]) if params[:name]
      query
    end

    api :GET, "/organizations/:organization_id/jenkins_users/:id", N_("Get jenkins user by identifier")
    param_group :jenkins_user_id
    def show
      respond_for_show(:resource => @jenkins_user)
    end

    api :PUT, "/organizations/:organization_id/jenkins_users/:id", N_("Update jenkins user")
    param_group :jenkins_user_id
    param_group :jenkins_user
    def update
      if jenkins_user_params[:token].empty?
        @jenkins_user.update_attributes!(jenkins_user_params.except(:token).except(:name))
      else
        @jenkins_user.update_attributes!(jenkins_user_params.except(:name))
      end
      @jenkins_user.save!

      respond_for_show(:resource => @jenkins_user)
    end

    api :POST, "/organizations/:organization_id/jenkins_users/:id", N_("Update jenkins user")
    param_group :jenkins_user_id
    param_group :jenkins_user
    def create
      @jenkins_user = JenkinsUser.new(jenkins_user_params)
      @jenkins_user.organization = @organization
      @jenkins_user.save!

      respond_for_show(:resource => @jenkins_user)
    end

    api :DELETE, "/organizations/:organization_id/jenkins_users/:id", N_("Update jenkins user")
    param_group :jenkins_user_id
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

    def jenkins_user_params
      params.require(:jenkins_user).permit(:name, :token)
    end

  end
end