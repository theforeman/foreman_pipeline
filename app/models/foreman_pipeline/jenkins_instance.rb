require 'jenkins_api_client'

module ForemanPipeline
  class JenkinsInstance < Katello::Model
    self.include_root_in_json = false

    attr_accessor :client, :server_version
    include Katello::Glue
    include Glue::ElasticSearch::JenkinsInstance
    include ForemanPipeline::Authorization::JenkinsInstance

    attr_accessible :name, :url, :organization_id, :pubkey, :jenkins_home, :cert_path, :jenkins_user_id

    belongs_to :organization
    has_many :jobs, :class_name => "ForemanPipeline::Job", :dependent => :nullify
    belongs_to :jenkins_user, :class_name => "ForemanPipeline::JenkinsUser"

    FILEPATH_REGEX = /^(\/|~)[a-z0-9\-_.\/]*[^\/]$/i

    validates :name, :presence => true
    validates :cert_path, :format => {:with => FILEPATH_REGEX }
    validates :url, :uniqueness => true, :format => { :with => /^(http|https):\/\/\S+:\d{1,4}$/}
    validates :organization, :presence => true
    validates :jenkins_home, :format => { :with => FILEPATH_REGEX }

    # TODO: loose coupling
    def create_client(username = nil, password = nil)
      fail "Cannot create Jenkins client: no url in Jenkins Instance" if url.nil?
      fail "Token required if username given." if !username.nil? && password.nil?

      if !@client.nil? && @client.username.nil? && !username.nil?
        @client = new_client username, password
      else
        @client ||= new_client username, password
      end
      @client
    end

    private

    def authenticated_client(username, password, hash_args)
      JenkinsApi::Client.new(hash_args.merge({:username => username,
                                              :password => password}))
    end

    def new_client(username, password)
      hash_args = {:server_url => url, :log_level => Logger::DEBUG}
      return JenkinsApi::Client.new(hash_args) if username.nil?
      authenticated_client username, password, hash_args
    end

  end
end