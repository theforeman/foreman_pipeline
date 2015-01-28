require 'jenkins_api_client'

module Integration
  class JenkinsInstance < Katello::Model
    self.include_root_in_json = false

    attr_accessor :client 
    include Katello::Glue
    include Glue::ElasticSearch::JenkinsInstance
    include Integration::Authorization::JenkinsInstance

    belongs_to :organization
    has_many :jobs, :inverse_of => :jenkins_instance

    validates :name, :presence => true
    validates :url, :presence => true
    validates :organization, :presence => true

    def create_client
      @client = JenkinsApi::Client.new(:server_url => url, :log_level => Logger::DEBUG)
    end

    
  end
end