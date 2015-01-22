module Integration
  class Api::JobsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index, :available_tests]

    before_filter :find_job, :only => [:update, :show, :destroy, :set_content_view, :set_hostgroup, :available_tests,
                  :add_tests, :remove_tests, :set_resource, :available_resources, :set_jenkins]

    before_filter :load_search_service, :only => [:index, :available_tests]

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
      @job.compute_resource = nil
      @job.save!
      respond_for_show
    end

    def set_jenkins
      @job.jenkins_instance = JenkinsInstance.find(params[:jenkins_instance_id])
      @job.save!
      respond_for_show
    end
    
    def remove_tests
      ids = params[:test_ids]
      @tests = Test.where(:id => ids)
      @job.test_ids = (@job.test_ids - @tests.map {|t| t.id}).uniq
      @job.save!
      respond_for_show
    end

    def available_tests
      ids = Test.where(:organization_id => @organization).readable.map(&:id)

      filters = [:terms => {:id => ids - @job.test_ids}]
      filters << {:term => {:name => params[:name]}} if params[:name]

      options = {
        :filters => filters,
        :load_records? => true 
      }

      tests = item_search(Test, params, options)
      respond_for_index(:collection => tests)
    end

    def add_tests
      ids = params[:test_ids]
      @tests = Test.where(:id => ids)
      @job.test_ids = (@job.test_ids + @tests.map {|t| t.id}).uniq
      @job.save!
      respond_for_show
    end

    def set_resource
      @job.compute_resource = ComputeResource.find(params[:resource_id])
      @job.save!
      respond_for_show
    end

    def available_resources
      @compute_resources = @job.hostgroup.compute_profile.compute_attributes.map(&:compute_resource) rescue []
      # binding.pry
      render "api/v2/compute_resources/index"
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