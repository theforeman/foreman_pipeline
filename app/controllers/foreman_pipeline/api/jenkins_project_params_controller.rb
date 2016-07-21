module ForemanPipeline
  class Api::JenkinsProjectParamsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_action :find_jenkins_project_param, :only => [:update]

    api :PUT, "/organizations/:organization_id/jenkins_project_params/:id", N_("Update jenkins project param")
    param :organization_id, :number, :desc => N_("Organization identifier"), :required => true
    param :id, :number, :desc => N_("Jenkins project parameter identifier")
    param :name, String, :desc => N_("Parameter's name")
    param :type, %w(boolean string text), :desc => N_("Parameter's type")
    param :value, String, :desc => N_("Parameter's value")
    param :description, String, :desc => N_("Parameter's description")
    def update
      @jenkins_project_param.update_attributes!(jenkins_project_param_params)
      @jenkins_project_param.save!
      respond_for_show(:resource => @jenkins_project_param)
    end

    private

    def find_jenkins_project_param
      @jenkins_project_param = JenkinsProjectParam.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find Jenkins Project Param with id: #{params[:id]}" if @jenkins_project_param.nil?
      @jenkins_project_param
    end

    def jenkins_project_param_params
      params.require(:jenkins_project_param).permit(:name, :type, :value, :description)
    end
  end
end