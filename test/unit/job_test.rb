require 'foreman_pipeline_test_helper'

class JobTest < ActiveSupport::TestCase

  def setup
    @organization = get_organization
    @compute_resource = FactoryGirl.create(:compute_resource, :libvirt)
    @hostgroup = FactoryGirl.create(:pipeline_hostgroup)
    @content_view = FactoryGirl.create(:katello_content_view)
    @jenkins_user = FactoryGirl.create(:jenkins_user, :organization => get_organization)
    @jenkins_instance = FactoryGirl.create(:jenkins_instance, :jenkins_user => @jenkins_user, :organization => get_organization)
    @environment = FactoryGirl.create(:katello_environment, :library)
  end

  test "should find target cv" do
    cv = Katello::ContentView.find(katello_content_views(:acme_default).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    target_v = cv.content_view_versions.select { |v| v.environments.include?(env) && !v.environments.include?(to_env) }.first
    assert_equal target_v, job.target_cv_version
  end

  test "should not find target cv" do
    cv = Katello::ContentView.find(katello_content_views(:acme_default).id)
    env = Katello::KTEnvironment.find(katello_environments(:test).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env)

    assert_equal nil, job.target_cv_version
  end

  test "should find envs for promotion" do
    cv = Katello::ContentView.find(katello_content_views(:acme_default).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)
    to_env2 = Katello::KTEnvironment.find(katello_environments(:staging).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env, to_env2])
    assert_equal [to_env, to_env2], job.envs_for_promotion
  end

  test "envs_for_promotion should exclude one env from promotions" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)
    to_env2 = Katello::KTEnvironment.find(katello_environments(:staging).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env, to_env2])
    assert_equal [to_env2], job.envs_for_promotion
  end

  test "job can be promoted" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)
    to_env2 = Katello::KTEnvironment.find(katello_environments(:staging).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env, to_env2])
    assert job.can_be_promoted?
  end

  test "job cannot be promoted" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    refute job.can_be_promoted?
  end

  test "is promotion safe" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)
    to_env2 = Katello::KTEnvironment.find(katello_environments(:staging).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env, to_env2])
    assert job.promotion_safe?
  end

  test "is not promotion safe" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env)
    refute job.promotion_safe?
  end

  test "is not promotion safe again" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    refute job.promotion_safe?
  end

  test "should detect env succession violation" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:test).id)

    job = ForemanPipeline::Job.new(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    job.save
    assert_equal "Environment succession violation: #{to_env.name}", job.errors[:base].first
  end

  test "was not yet promoted" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [])
    assert job.not_yet_promoted?
  end

  test "there should be env for promotion" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:dev).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:test).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    assert_equal 1, job.envs_for_promotion.count
    assert_equal to_env, job.envs_for_promotion.first
  end

  test "there shloud not be env for promotion" do
    cv = Katello::ContentView.find(katello_content_views(:library_dev_view).id)
    env = Katello::KTEnvironment.find(katello_environments(:library).id)
    to_env = Katello::KTEnvironment.find(katello_environments(:dev).id)

    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => cv,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => env,
                                      :to_environments => [to_env])
    assert job.envs_for_promotion.empty?
  end

  test "should not save job with composite view" do
    composite = Katello::ContentView.find(katello_content_views(:composite_view).id)
    job = ForemanPipeline::Job.new(:name => "test job",
                                   :content_view => composite)
    refute job.save
    assert job.errors['base'].include? "Cannot add content view, only non-composites allowed."
  end

  test "should not save job where compute profile on hg is missing" do
    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :content_view => @content_view,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => @environment)
    refute job.is_valid?
  end

  test "should not save job when compute resource is not available through hostgroup" do
    job = ForemanPipeline::Job.create(:name => "test job",
                                    :organization => @organization,
                                    :hostgroup => Hostgroup.find(hostgroups(:common).id),
                                    :compute_resource => @compute_resource,
                                    :content_view => @content_view,
                                    :jenkins_instance => @jenkins_instance,
                                    :environment => @environment)
    refute job.is_valid?
  end
end
