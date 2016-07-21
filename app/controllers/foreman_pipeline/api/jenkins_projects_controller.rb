module ForemanPipeline
  class Api::JenkinsProjectsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_action :find_jenkins_project, :only => [:show]

    api :GET, "/organizations/:organization_id/jenkins_projects/:id", N_("Get jenkins project by identifier")
    param :organization_id, :number, :desc => N_("Organization identifier")
    param :id, :number, :desc => N_("Jenkins project identifier")
    def show
      respond_for_show(:resource => @jenkins_project)
    end

    private

    def find_jenkins_project
      @jenkins_project = JenkinsProject.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find Jenkins Project with id: #{params[:id]}" if @jenkins_project.nil?
      @jenkins_project
    end

    def jenkins_project_params
      params.require(:jenkins_project).permit(:name)
    end

  end
end