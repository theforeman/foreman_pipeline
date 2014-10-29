module Integration
  class Api::JobsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index]
    before_filter :find_job, :only => [:update, :show, :destroy, :set_content_view, :set_hostgroup]

    def index
       ids = Job.readable.where(:organization_id => @organization.id).pluck(:id)
       filters = [:terms => {:id => ids}]
       filters << {:terms => {:content_view => [params[:content_view]] }} if params[:content_view]

      options = {
         :filters => filters,
         :load_records? => true
      }
       
      respond_for_index(:collection => item_search(Job, params, options))
    end

    def show
      respond_for_show(:resource => @job)
    end

    def create
      @job = Job.new(job_params)
      @job.organization = @organization
      @job.save!

      respond_for_show(:resource => @job)
    end

    def update
      @job.update_attributes!(job_params)
      @job.save!

      respond_for_show(:resource => @job)
    end

    def destroy
      @job.destroy
      respond_for_show(:resource => @job)
    end

    def set_content_view
      @job.content_view = Katello::ContentView.find(params[:content_view_id])
      @job.save!
      respond_for_show
    end

    def set_hostgroup
      @job.hostgroup = Hostgroup.find(params[:hostgroup_id])
      @job.save!
      respond_for_show
    end

    protected

    def find_job
      @job = Job.find_by_id(params[:id])
      fail HttpErrors::NotFound "Could not find job with id #{params[:id]}" if @job.nil?
      @job 
    end

    def job_params
      params.require(:job).permit(:name, :content_view_id, :hostgroup_id)
    end
  end
end