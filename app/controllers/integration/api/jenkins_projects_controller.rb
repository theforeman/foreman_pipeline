module Integration
  class JenkinsProjectsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create]
    before_filter :find_jenkins_project, :only => [:show, :update, :destroy]

    def show
      respond_for_show(:resource => @jenkins_project)
    end

    def destroy
      @jenkins_project.destroy
      respond_for_show(:resource => @jenkins_project)
    end

    def update
      @jenkins_project.update_attributes!(jenkins_project_params)
      @jenkins_project.save!
      respond_for_show(:resource => @jenkins_project)
    end

    def create
      @jenkins_project = JenkinsProject.new(jenkins_project_params)
      @jenkins_project.organization = @organization
      @jenkins_project.save!
      respond_for_show(:resource => @jenkins_project)
    end

    def list_all
      # task = sync_task(::Actions::Integration::Jenkins::ListAll, :job_id => params[:job_id])
      # projects = task.output[:projects].each {|p| JenkinsProject.new(:name => p)}
      # respond_for_index(:collection => projects)
    end

    def list
      task = sync_task(::Actions::Integration::Jenkins::List, :job_id => params[:job_id], :filter => params[:filter])
      projects = task.output[:projects].each {|p| JenkinsProject.new(:name => p)}
      respond_for_index(:collection => projects)
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