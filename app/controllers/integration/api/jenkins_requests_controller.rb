module Integration
  class Api::JenkinsRequestsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_job

    def list
      fail "filter string not given" if params[:filter].blank?
      task = async_task(::Actions::Integration::Jenkins::List, :job_id => params[:job_id], :filter => params[:filter])
      respond_for_async(:resource => task)
    end

    private 

    def find_job
      @job = Job.find_by_id(params[:job_id])
      fail ::Katello::HttpErrors::NotFound, "Could not find job with id #{params[:job_id]}" if @job.nil?
      @job 
    end
    
  end
end