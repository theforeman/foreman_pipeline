require 'foreman_pipeline_plugin_test_helper'

class JobTest < ActiveSupport::TestCase

  def setup
    @organization = get_organization
    @compute_resource = FactoryGirl.create(:compute_resource, :libvirt)
    @hostgroup = FactoryGirl.create(:pipeline_hostgroup, :compute_profile => @compute_profile)
    @content_view = FactoryGirl.create(:katello_content_view)
    @jenkins_user = FactoryGirl.create(:jenkins_user, :organization => get_organization)
    @jenkins_instance = FactoryGirl.create(:jenkins_instance, :jenkins_user => @jenkins_user, :organization => get_organization)
    @environment = FactoryGirl.create(:katello_environment, :library)
  end

  test "should validate host" do
    job = ForemanPipeline::Job.create(:name => "test job",
                                      :organization => @organization,
                                      :hostgroup => @hostgroup,
                                      :compute_resource => @compute_resource,
                                      :content_view => @content_view,
                                      :jenkins_instance => @jenkins_instance,
                                      :environment => @environment)
    assert job.is_valid?
  end

end