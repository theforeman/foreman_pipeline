module ForemanPipeline
  class Api::JobsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index, :add_projects, :available_paths]

    before_filter :find_job, :only => [:update, :show, :destroy, :set_content_view,
                                       :set_hostgroup, :set_resource, :available_resources,
                                       :set_jenkins, :set_environment, :run_job,
                                       :add_projects, :remove_projects, :set_paths,
                                       :remove_paths, :add_paths, :current_paths, :available_paths]

    before_filter :load_search_service, :only => [:index]

    def index
      ids = Job.readable.where(:organization_id => @organization.id).pluck(:id)
      filters = [:terms => {:id => ids}]       

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

    # TODO: refactor and remove repetitive methods -> map all set actions onto update
    def set_content_view
      @job.content_view = Katello::ContentView.find(params[:content_view_id])
      @job.save!
      respond_for_show
    end

    def set_hostgroup
      @job.hostgroup = Hostgroup.find(params[:hostgroup_id])
      @job.compute_resource = nil
      @job.save!
      respond_for_show
    end

    def set_jenkins
      instance = JenkinsInstance.find(params[:jenkins_instance_id])
      @job.jenkins_instance = instance
      @job.save!
      respond_for_show
    end
    
    def set_environment
      @job.environment = Katello::KTEnvironment.find(params[:environment_id])
      @job.save!
      respond_for_show
    end    

    def set_resource
      @job.compute_resource = ComputeResource.find(params[:resource_id])
      @job.save!
      respond_for_show
    end

    def add_paths
      @job.path_ids = (@job.path_ids + params[:path_ids]).uniq
      @job.save!
      respond_for_show
    end

    def remove_paths
      @job.path_ids = (@job.path_ids - params[:path_ids]).uniq
      @job.save!
      respond_for_show
    end

    def current_paths
      paths = @job.paths.map(&:full_path)

      current = paths.inject([]) do |result, path|
        result << { :environments => path }
      end

      collection = {
        :results => current,
        :total => current.size,
        :subtotal => current.size
      }      
      respond_for_index(:collection => collection)
    end

    def available_paths
      all_paths = @organization.promotion_paths.map(&:shift)
      available = (all_paths - @job.paths).map(&:full_path)

      paths = available.inject([]) do |result, path|
        result << { :environments => path }
      end

      collection = {
        :results => paths,
        :total => paths.size,
        :subtotal => paths.size
      }
      respond_for_index(:collection => collection)
    end

    def available_resources
      @compute_resources = @job.hostgroup.compute_profile.compute_attributes.map(&:compute_resource) rescue []
      render "api/v2/compute_resources/index"
    end

    def run_job      
      if @job.manual_trigger
        task = async_task(::Actions::ForemanPipeline::Job::RunJobManually, @job)
        render :nothing => true            
      else
        fail ::Katello::HttpErrors::Forbidden, "Running manually not allowed for Job: #{@job.name}. Try setting it's :manual_trigger property."
      end
    end

    def add_projects
      rollback = {:occured => false}
      Job.transaction do
        projects = params[:projects].map do |p|
          JenkinsProject.create(:name => p, :organization => @organization) 
        end
        projects_to_add = projects.delete_if { |p| @job.jenkins_projects.include? p }
        @job.jenkins_projects = @job.jenkins_projects + projects_to_add
        @job.save!

        projects_to_add.each do |project|
          project.reload
          task = sync_task(::Actions::ForemanPipeline::Jenkins::GetBuildParams, :job_id => @job.id, :name => project.name)
          
          unless task.output[:build_params]
            raise ActiveRecord::Rollback
            rollback[:occured] = true
            rollback[:project_name] = project.name
          end
          task.output[:build_params].each do |param|
            new_param = JenkinsProjectParam.new(:name => param[:name],
                                                :type => param[:type],
                                                :description => param[:description],
                                                :value => param[:default])
            new_param.organization = @organization
            new_param.jenkins_project = project
            new_param.save!
          end
        end
      end
      if rollback[:occured]
        fail ::Katello::HttpErrors::NotFound, "Could not retrieve build params for Jenkins project: #{rollback[:project_name]}"
      else
        respond_for_show        
      end
    end

    def remove_projects
      ids = params[:project_ids]
      jj_projects = JobJenkinsProject.where(:jenkins_project_id => ids)
      jj_projects.map(&:destroy)
      respond_for_show
    end

    protected

    def find_job
      @job = Job.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find job with id #{params[:id]}" if @job.nil?
      @job 
    end

    def job_params
      params.require(:job).permit(:name, :manual_trigger, :sync_trigger, :levelup_trigger, :projects, :promote)
    end

    def format_paths(paths)
      formated_paths = paths.inject([]) do |result, path|
        result << { :environments => path }
      end

      collection = {
        :results => formated_paths,
        :total => formated_paths.size,
        :subtotal => formated_paths.size
      }
      respond_for_index(:collection => collection)
    end
  end
end