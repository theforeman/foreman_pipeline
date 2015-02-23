require 'jenkins_api_client'

module Integration
  class JenkinsInstance < Katello::Model
    self.include_root_in_json = false

    attr_accessor :client, :server_version
    include Katello::Glue
    include Glue::ElasticSearch::JenkinsInstance
    include Integration::Authorization::JenkinsInstance

    belongs_to :organization
    has_many :jobs, :inverse_of => :jenkins_instance

    FILEPATH_REGEX = /^(\/|~)[a-z0-9\-_.\/]*[^\/]$/i
    
    validates :name, :presence => true
    validates :cert_path, :format => {:with => FILEPATH_REGEX }
    validates :url, :uniqueness => true, :format => { :with => /^(http|https):\/\/\S+:\d{1,4}$/}
    validates :organization, :presence => true
    validates :jenkins_home, :format => { :with => FILEPATH_REGEX }


    def create_client
      @client ||= JenkinsApi::Client.new(:server_url => url, :log_level => Logger::DEBUG)
    end

    def check_jenkins_server
      create_client
      @client.get_jenkins_version
    end    
    
  end
end