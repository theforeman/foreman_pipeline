module ForemanPipeline
  class Api::JenkinsProjectParamsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_jenkins_project_param, :only => [:update]

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