require "foreman_pipeline_test_helper"

class ForemanPipeline::Api::JenkinsUsersControllerTest < ActionController::TestCase
  setup do
    setup_engine_routes
    @org = get_organization
    @user = ForemanPipeline::JenkinsUser.find(jenkins_users(:jenkins_user_one).id)
  end

  test "should get index" do
    get :index, :organization_id => @org.id
    assert_response :success
    response = JSON.parse(@response.body)
    assert_equal 1, response['total']
    assert_equal @user.name, response['results'].first['name']
  end

  test "should get show" do
    get :show, :organization_id => @org.id,
               :id => @user.id
    assert_response :success
    resp = JSON.parse(@response.body)
    assert_equal @user.name, resp['name']
  end

  test "should update jenkins user" do
    put :update, :organization_id => @org.id,
                 :id => @user.id,
                 :jenkins_user => { :id => @user.id,
                                    :name => "New username" }
    assert_response :success
  end

  test "should create jenkins user" do
    post :create, :organization_id => @org.id,
                  :jenkins_user => { :name => "Brand new user",
                                     :organization_id => @org.id,
                                     :token => "AndTheSilenceGaveNoToken" }
    assert_response :success
  end

  test "should destroy jenkins user" do
    delete :destroy, :organization_id => @org.id,
                     :id => @user.id
    assert_response :success
  end
end
