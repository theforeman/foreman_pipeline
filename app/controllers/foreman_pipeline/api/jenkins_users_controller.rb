module ForemanPipeline
  class Api::JenkinsUsersController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index]
    before_filter :find_jenkins_user, :only => [:show, :destroy, :update]
    before_filter :find_job, :only => [:create]

    def index
       ids = JenkinsUser.readable
            .where(:organization_id => @organization.id,
                   :jenkins_instance_id => params[:jenkins_instance_id],
                   :owner_id => ::User.current.id)
            .pluck(:id)
      filters = [:terms => {:id => ids}]       

      options = {
         :filters => filters,
         :load_records? => true
      }
      respond_for_index(:collection => item_search(JenkinsUser, params, options))
    end

    def show
      respond_for_show(:resource => @jenkins_user)
    end

    def update
      if jenkins_user_params[:token].empty? || jenkins_user_params[:token].nil?
        @jenkins_user.update_attributes!(jenkins_user_params.except(:token).except(:name))      
      else
        @jenkins_user.update_attributes!(jenkins_user_params.except(:name))      
      end
      @jenkins_user.save!

      respond_for_show(:resource => @jenkins_user)
    end

    def create
      @jenkins_user = JenkinsUser.new(jenkins_user_params)
      @jenkins_user.owner = ::User.current
      fail ::Katello::HttpErrors::Conflict, "Could not create Jenkins User:
                                             No Jenkins Instance set for Job " if @job.jenkins_instance.nil?
      @jenkins_user.jenkins_instance = @job.jenkins_instance
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

    def find_job
      @job = Job.find_by_id(params[:job_id])
      fail ::Katello::HttpErrors::NotFound, "Could not find job with id #{params[:job_id]}" if @job.nil?
      @job 
    end

    def jenkins_user_params
      params.require(:jenkins_user).permit(:name, :token, :job_id)
    end
    
  end
end