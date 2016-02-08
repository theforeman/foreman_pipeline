require 'foreman_pipeline_test_helper'

class JobFilterTest < ActiveSupport::TestCase
  def setup
    @organization = get_organization
    @filter = ForemanPipeline::JobFilter.new
    @job = ForemanPipeline::Job.find(jobs(:valid).id)
    @dev = Katello::KTEnvironment.find(katello_environments(:dev).id)
  end

  test "allowed? is true for properly configured job" do
    @job.update(:name => "allowed_job",
                :to_environments => [@dev])
    assert @filter.allowed?(@job)
  end

  test "allowed? is false for job already promoted to all to_envs" do
    @job.update(:name => "promoted_job",
                :content_view => Katello::ContentView.find(katello_content_views(:library_dev_view).id),
                :to_environments => [@dev])
    refute @filter.allowed?(@job)
  end

  test "allowed? is false for misconfigured job" do
    @job.update(:name => "allowed_job",
                :jenkins_instance => nil)
    refute @filter.allowed?(@job)
  end

  test "job is allowed to run if target cv version is available" do
    @job.update(:name => "allowed_job",
                :to_environments => [@dev])
    assert @filter.allow_run_for?(@job)
  end

  test "only jobs with repo in associated cv are allowed to run on repo sync" do
    fedora_repo = Katello::Repository.find(katello_repositories(:fedora_17_x86_64).id)
    job = ForemanPipeline::Job.find(jobs(:runs_on_sync).id)
    allowed_jobs = @filter.allowed_jobs_for_repo(fedora_repo)
    assert_equal 1, allowed_jobs.count
    assert_equal job, allowed_jobs.first
  end

  test "only jobs with appropriate cv are allowed to run when cv published/promoted" do
    cvv = Katello::ContentViewVersion.find(katello_content_view_versions(:library_view_version_2).id)
    job = ForemanPipeline::Job.find(jobs(:runs_on_levelup).id)
    allowed_jobs = @filter.allowed_jobs_for_cvv(cvv)
    assert_equal 1, allowed_jobs.count
    assert_equal job, allowed_jobs.first
  end

  test "only jobs in library are allowed to run for cvs published for the first time" do
    job = ForemanPipeline::Job.find(jobs(:runs_on_first_publish).id)
    cv = Katello::ContentView.find(katello_content_views(:no_environment_view).id)
    allowed_jobs = @filter.allowed_jobs_for_cv(cv)
    assert_equal 1, allowed_jobs.count
    assert_equal job, allowed_jobs.first
  end
end
