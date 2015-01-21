module Integration
  class JenkinsInstance < Katello::Model
    self.include_root_in_json = false

    attr_accessor :client 
    include Katello::Glue
    include Glue::ElasticSearch::JenkinsInstance
    include Integration::Authorization::JenkinsInstance

    belongs_to :organization
    has_many :jobs

    validates :name, :presence => true
    validates :url, :presence => true
    validates :organization, :presence => true


    def self.find_instance(id)
      instance = JenkinsInstance.find(id)
      # instance.client =
    end

    
  end
end