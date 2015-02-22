require 'integration_plugin_test_helper'

module Integration
  describe JenkinsInstance do
    
    before(:each) do
      @instance = JenkinsInstance.create(:name => 'test_jenkins_instance',
                                          :url => 'http://somewhere.com',
                                          :cert_path => "/home/user/.ssh/foreman-jenkins",
                                          :jenkins_home => "/var/lib/jenkins")

    end

    describe "in valid state" do
      # it "should be valid" do
      #   @instance.must_be :valid?
      #   @instane.errors[:base].must_be_empty
      # end
    end

    describe "in invalid state" do
      it "sould be invalid without org" do
        @instance.wont_be :valid?
        @instance.errors.wont_be_empty
      end
    end


  end
end