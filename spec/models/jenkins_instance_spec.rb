require 'integration_plugin_test_helper'

module Integration
  describe JenkinsInstance do
    include Katello::OrchestrationHelper

    let(:i_name) {"test_jenkins_instance"}
    let(:certpath) {"/home/user/.ssh/foreman-jenkins"}
    let(:home) {"/var/lib/jenkins"}
    let(:valid_url) {"http://somewhere.com:8080"}

    before(:each) do
      disable_org_orchestration

      @org = get_organization
      @instance = JenkinsInstance.create(:name => i_name,
                                          :url => valid_url,
                                          :cert_path => certpath,
                                          :jenkins_home => home,
                                          :organization_id => @org.id)
    end

    describe "in valid state" do
      it "should be valid" do
        @instance.must_be :valid?
        @instance.errors[:base].must_be_empty
      end
    end

    describe "in invalid state" do
      before {@instance = JenkinsInstance.new}

      it "sould be invalid when empty" do
        @instance.wont_be :valid?
        @instance.errors[:organization].wont_be_empty
        @instance.errors[:name].wont_be_empty
        @instance.errors[:url].wont_be_empty
        @instance.errors[:cert_path].wont_be_empty
        @instance.errors[:jenkins_home].wont_be_empty
      end      
    end

    describe "creating" do
      it "should be able to create" do
        @instance.wont_be :nil?
      end

      it "should not create with invalid url"  do
        # inst = JenkinsInstance.create(:name => i_name,
        #                               :url => "url_input_fail",
        #                               :cert_path => )
      end
    end

    

    describe "updating" do
      
      it "should accept name" do
        j = JenkinsInstance.find_by_name(i_name)
        j.wont_be :nil?
        new_name = j.name << "_name_changed"
        k = JenkinsInstance.update(j.id, :name => new_name)
        k.name.must_equal new_name
      end

      it "should accept jenkins_home" do
        j = JenkinsInstance.find_by_name(i_name)
        j.wont_be :nil?
        new_jenkins_home = j.jenkins_home << "/subfolder"
        k = JenkinsInstance.update(j.id, :jenkins_home => new_jenkins_home)
        k.jenkins_home.must_equal new_jenkins_home
      end


    end


  end
end