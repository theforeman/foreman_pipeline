module ForemanPipeline
  class Api::JenkinsRequestsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_job

    api :GET, "/organizations/:organization_id/jenkins_requests/list"
    param :organization_id, :number, :desc => N_("Organization identifier"), :required => true
    param :job_id, :number, :desc => N_("Job identifier")
    param :filter, String, :desc => N_("All jenkins projects with name matching this string will be retrieved")
    def list
      fail "filter string not given" if params[:filter].blank?
      task = async_task(::Actions::ForemanPipeline::Jenkins::List, :job_id => params[:job_id], :filter => params[:filter])
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