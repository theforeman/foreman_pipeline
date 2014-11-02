
module Integration
  class Job < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::Job
    include Integration::Authorization::Job

    belongs_to :content_view, :class_name => 'Katello::ContentView'
    belongs_to :hostgroup
    belongs_to :organization
    has_and_belongs_to_many :tests, :join_table => :integration_jobs_tests
    
    # validates :content_view, :presence => true
    # validates :hostgroup, :presence => true
    validates :name, :presence => true
    validates :organization, :presence => true

  end
end