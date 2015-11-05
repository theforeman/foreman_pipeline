require 'foreman_pipeline_plugin_test_helper'

class JenkinsInstanceTest < ActiveSupport::TestCase

  def setup
    @org = get_organization
    @valid_url = "http://somewhere.com:8080"
    @valid_home = "/var/lib/jenkins"
    @valid_cert_path = "/home/user/.ssh/foreman-jenkins"
  end

  test "should be valid" do
    @instance = ForemanPipeline::JenkinsInstance.create(:name => "test_jenkins_instance",
                                                        :url => @valid_url,
                                                        :cert_path => @valid_cert_path,
                                                        :jenkins_home => @valid_home,
                                                        :organization_id => @org.id)
    assert @instance.errors.empty?
  end

  test "should have url" do
    @instance = ForemanPipeline::JenkinsInstance.create(:name => "test_jenkins_instance",
                                                        :url => "invalid url",
                                                        :cert_path => @valid_cert_path,
                                                        :jenkins_home => @valid_home,
                                                        :organization_id => @org.id)
    refute @instance.errors.empty?
  end


end