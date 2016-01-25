require 'foreman_pipeline_test_helper'

class ForemanPipeline::Api::JobsControllerTest < ActionController::TestCase
   include ::Support::ForemanTasks::Task

  setup do
    stub_tasks!
    setup_engine_routes
    @job = jobs(:valid)
    @org = get_organization
  end

  test "should get index" do
    get :index, { :organization_id => @org.id}
    assert_response :success
    response = ActiveSupport::JSON.decode(@response.body)
    assert_equal 1, response['total']
    assert_equal "valid job", response['results'].first['name']
  end

  test 'should get show' do
    get :index, { :organization_id => @org.id}
    assert_response :success
    response = ActiveSupport::JSON.decode(@response.body)
    assert_equal "valid job", response['results'].first['name']
  end

  test 'should create new job' do
    post :create, :organization_id => @org.id,
                  :job => { :name => "new job",
                            :manual_trigger => false,
                            :levelup_trigger => false,
                            :sync_trigger => false }
    assert_response :success
  end

  test 'should not create new job without name' do
    post :create, :organization_id => @org.id,
                  :job => { :manual_trigger => false,
                            :levelup_trigger => false,
                            :sync_trigger => false }
    assert_response :unprocessable_entity
    response = ActiveSupport::JSON.decode(@response.body)
    assert_equal ["can't be blank"], response['errors']['name']
  end

  test 'should update job' do
    put :update, :organization_id => @org.id,
                  :job => { :id => @job.id,
                            :name => "updated job",
                            :manual_trigger => true,
                            :levelup_trigger => false,
                            :sync_trigger => false },
                  :id => @job.id
    assert_response :success
  end

  test 'should not update job with nil as a name' do
    put :update, :organization_id => @org.id,
                  :job => { :id => @job.id,
                            :name => nil,
                            :manual_trigger => true,
                            :levelup_trigger => false,
                            :sync_trigger => false },
                  :id => @job.id
    assert_response :unprocessable_entity
  end

  test 'should delete job' do
    delete :destroy, :organization_id => @org.id,
                     :id => @job.id
    assert_response :success
  end

  test 'should set content view' do
    cv_id = katello_content_views(:acme_default).id
    put :set_content_view, :organization_id => @org.id,
                           :id => @job.id,
                           :content_view_id => cv_id
    assert_response :success
  end

  test 'should set hostgroup' do
    hg_id = hostgroups(:common).id
    put :set_hostgroup, :organization_id => @org.id,
                        :id => @job.id,
                        :hostgroup_id => hg_id
    assert_response :success
  end

  test 'should set jenkins' do
    jenkins_id = jenkins_instances(:one).id
    put :set_jenkins, :organization_id => @org.id,
                      :id => @job.id,
                      :jenkins_instance_id => jenkins_id
    assert_response :success
  end

  test 'should set environment' do
    env_id = katello_environments(:library).id
    put :set_environment, :organization_id => @org.id,
                          :id => @job.id,
                          :environment_id => env_id
    assert_response :success
  end

  test "should set compute resource" do
    compute_id = compute_resources(:ec2).id
    put :set_resource, :organization_id => @org.id,
                        :id => @job.id,
                        :resource_id => compute_id
    assert_response :success
  end

  test "should not set compute resource" do
    compute_id = compute_resources(:mycompute).id
    put :set_resource, :organization_id => @org.id,
                        :id => @job.id,
                        :resource_id => compute_id
    assert_response :unprocessable_entity
  end

  test "should set to_environments" do
    ids = [katello_environments(:dev).id, katello_environments(:staging).id]
    put :set_to_environments, :organization_id => @org.id,
                              :id => @job.id,
                              :to_environment_ids => ids
    assert_response :success
  end

  test "should not set to_environments" do
    ids = [katello_environments(:beta).id]
    put :set_to_environments, :organization_id => @org.id,
                              :id => @job.id,
                              :to_environment_ids => ids
    assert_response :conflict
  end

  test "should list available paths" do
    get :available_paths, :organization_id => @org.id,
                          :id => @job.id
    resp = JSON.parse(@response.body)
    assert_equal "Dev", resp['results'].first['environments'][1]['name']
    assert_equal 4, resp['results'].count
  end

  test "should list available resources" do
    get :available_resources, :organization_id => @org.id,
                              :id => @job.id
    resp = JSON.parse(@response.body)
    assert_equal 2, resp.count
    ["bigcompute", "amazon123"].each do |item|
      assert resp.map { |hash| hash['name']}.include?(item)
    end
  end

  test "should run job" do
    get :run_job, :organization_id => @org.id,
                  :id => @job.id
    assert_response :success
  end

  test "should add jenkins projects" do
    assert_sync_task(::Actions::ForemanPipeline::Jenkins::GetBuildParams, :job_id => @job.id, :name => "foo")
    put :add_projects, :organization_id => @org.id,
                       :id => @job.id,
                       :projects => ["foo"]
    assert_response :success
  end

  test "remove jenkins projects" do
    ids = [jenkins_projects(:first).id, jenkins_projects(:second).id]
    put :remove_projects, :organization_id => @org.id,
                          :id => @job.id,
                          :projects => ids
    assert_response :success
  end
end
