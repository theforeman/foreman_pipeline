module Integration
  class JenkinsProjectsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create]

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
    
  end
end