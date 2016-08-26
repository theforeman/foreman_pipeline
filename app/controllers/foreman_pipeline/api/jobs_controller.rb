module ForemanPipeline
  class Api::JobsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering
    include Concerns::ApiControllerExtensions

    before_filter :find_organization, :only => [:create, :index, :add_projects, :available_paths]

    before_filter :find_job, :only => [:update, :show, :destroy, :set_content_view,
                                       :set_hostgroup, :set_resource, :available_resources,
                                       :set_jenkins, :set_environment, :run_job,
                                       :add_projects, :remove_projects, :set_to_environments,
                                       :available_paths]
    before_filter :job_filter, :only => [:run_job]

    def_param_group :job do
      param :name, String, :desc => N_("Name of the job"), :required => true
      param :manual_trigger, :bool, :desc => N_("Allow starting job manually"), :required => false
      param :sync_trigger, :bool, :desc => N_("Allow starting job on successful repo sync"), :required => false
      param :levelup_trigger, :bool, :desc => N_("Allow starting job on successful content view publish/promote"), :required => false
      param :promote, :bool, :desc => N_("Allow starting job manually"), :required => false
    end

    def_param_group :job_id do
      param :organization_id, :number, :desc => N_("organization identifier"), :required => true
      param :id, :number, :desc => N_("job identifier"), :required => true
    end

    api :GET, "/organizations/:organization_id/jobs", N_("List jobs")
    param :organization_id, :number, :desc => N_("organization identifier"), :required => true
    param :name, String, :desc => N_("Name of the job")
    def index
      respond_for_index(:collection => scoped_search(index_relation.uniq, params[:sort_by], params[:sort_order]))
    end

    def index_relation
      query = Job.readable.where(:organization_id => @organization.id)
      query = query.where(:name => params[:name]) if params[:name]
      query = query.where(:manual_trigger => params[:manual_trigger]) if params[:manual_trigger]
      query = query.where(:sync_trigger => params[:sync_trigger]) if params[:sync_trigger]
      query = query.where(:levelup_trigger => params[:levelup_trigger]) if params[:levelup_trigger]
      query = query.where(:promote => params[:promote]) if params[:promote]
      query
    end

    api :GET, "/organizations/:organization_id/jobs/:id", N_("Get job by identifier")
    param_group :job_id
    def show
      respond_for_show(:resource => @job)
    end

    api :POST, "/organizations/:organization_id/jobs/", N_("Create new job")
    param :organization_id, :number, :desc => N_("Organization identifier"), :required => true
    param_group :job
    def create
      @job = Job.new(job_params)
      @job.organization = @organization
      @job.save!

      respond_for_show(:resource => @job)
    end

    api :PUT, "/organizations/:organization_id/jobs/:id", N_("Update job")
    param_group :job_id
    param_group :job
    def update
      @job.update_attributes!(job_params)
      @job.save!
      respond_for_show(:resource => @job)
    end

    api :DELETE, "/organizations/:organization_id/jobs/:id", N_("Delete job")
    param_group :job_id
    def destroy
      @job.destroy
      respond_for_show(:resource => @job)
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_content_view", N_("Set content view for job")
    param_group :job_id
    param :content_view_id, :number, :desc => N_("Content view id which will be set"), :required => true
    def set_content_view
      cv = Katello::ContentView.find(params[:content_view_id])
      @job.content_view = cv
      @job.save!
      respond_for_show
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_hostgroup", N_("Set hostgroup for job")
    param_group :job_id
    param :hostgroup_id, :number, :desc => N_("Hostgroup id which will be set"), :required => true
    def set_hostgroup
      @job.hostgroup = Hostgroup.find(params[:hostgroup_id])
      @job.compute_resource = nil
      @job.save!
      respond_for_show
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_jenkins", N_("Set jenkins instance for job")
    param_group :job_id
    param :jenkins_instance_id, :number, :desc => N_("Jenkins Instance id which will be set"), :required => true
    def set_jenkins
      instance = JenkinsInstance.find(params[:jenkins_instance_id])
      @job.jenkins_instance = instance
      @job.save!
      respond_for_show
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_environment", N_("Set environment for job")
    param_group :job_id
    param :environment_id, :number, :desc => N_("Environment id which will be set"), :required => true
    def set_environment
      @job.environment = Katello::KTEnvironment.find(params[:environment_id])
      @job.to_environments = []
      @job.save!
      respond_for_show
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_resource", N_("Set compute resource for job")
    param_group :job_id
    param :resource_id, :number, :desc => N_("Compute resource id which will be set"), :required => true
    def set_resource
      @job.compute_resource = ComputeResource.find(params[:resource_id])
      @job.save!
      respond_for_show
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/set_to_environments", N_("Set 'to environments' for the job")
    param_group :job_id
    param :path_ids, Array, :desc => N_("Identifiers of environments which are successors of job's environment")
    def set_to_environments
      @job.to_environment_ids = params[:to_environment_ids]
      @job.save!
      respond_for_show
    end

    api :GET, "/organizations/:organization_id/jobs/:id/available_paths", N_("List environment paths available for a job")
    param_group :job_id
    def available_paths
      available = []
      paths = []
      if params[:all_paths]
        available = @organization.readable_promotion_paths
        paths = available.inject([]) do |result, path|
          result << { :environments => [@organization.library] + path }
        end
        paths = [{ :environments => [@organization.library] }] if paths.empty?
      else
        available = @job.environment.full_paths rescue []
        paths = available.inject([]) do |result, path|
          result << { :environments => path }
        end
        paths = [{ :environments => [] }] if paths.empty?
      end

      collection = {
        :results => paths,
        :total => paths.size,
        :subtotal => paths.size
      }

      respond_for_index(:collection => collection)
    end

    api :GET, "/organizations/:organization_id/jobs/:id/available_resources", N_("List compute resources available for the job")
    param_group :job_id
    def available_resources
      @compute_resources = @job.available_compute_resources
      render "api/v2/compute_resources/index"
    end

    api :GET, "/organizations/:organization_id/jobs/:id/run_job", N_("Start job execution")
    param_group :job_id
    def run_job
      if @job.manual_trigger
        if @filter.allow_run_for? @job
          task = async_task(::Actions::ForemanPipeline::Job::RunJobManually, @job)
          render :nothing => true
        else
          fail ::Katello::HttpErrors::Forbidden, "Job cannot be allowed to run, check your configuration"
        end
      else
        fail ::Katello::HttpErrors::Forbidden, "Running manually not allowed for Job: #{@job.name}. Try setting it's :manual_trigger property."
      end
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/add_projects", N_("Add jenkins projects to the job")
    param_group :job_id
    param :projects, Array, :desc => N_("Names of the jenkins projects to be added to the job")
    def add_projects
      rollback = { :occured => false }
      Job.transaction do
        names = params[:projects].delete_if { |name| @job.jenkins_projects.map(&:name).include? name }
        projects = names.map do |name|
          JenkinsProject.create(:name => name, :organization_id => @organization.id, :job_id => @job.id)
        end

        projects.each do |project|
          task = sync_task(::Actions::ForemanPipeline::Jenkins::GetBuildParams, :job_id => @job.id, :name => project.name)

          unless task.output[:build_params]
            raise ActiveRecord::Rollback
            rollback[:occured] = true
            rollback[:project_name] = project.name
          end
          task.output[:build_params].each do |param|
            JenkinsProjectParam.create(:name => param[:name],
                                       :type => param[:type],
                                       :description => param[:description],
                                       :value => param[:default],
                                       :organization => @organization,
                                       :jenkins_project => project)
          end
        end
      end
      if rollback[:occured]
        fail ::Katello::HttpErrors::NotFound, "Could not retrieve build params for Jenkins project: #{rollback[:project_name]}"
      else
        respond_for_show
      end
    end

    api :PUT, "/organizations/:organization_id/jobs/:id/remove_projects", N_("Remove jenkins projects from the job")
    param_group :job_id
    param :projects, Array, :desc => N_("Identifiers of the projects to be removed from the job")
    def remove_projects
      ids = params[:project_ids]
      projects = JenkinsProject.where(:id => ids)
      projects.map(&:destroy)
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

    def job_filter
      @filter ||= ForemanPipeline::JobFilter.new
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