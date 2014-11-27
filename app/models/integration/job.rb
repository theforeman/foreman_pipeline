
module Integration
  class Job < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::Job
    include Integration::Authorization::Job

    belongs_to :content_view, :class_name => 'Katello::ContentView'
    belongs_to :hostgroup
    belongs_to :organization
    
    # rubocop:disable HasAndBelongsToMany
    has_and_belongs_to_many :tests, :join_table => :integration_jobs_tests

    has_many :content_view_repositories, :primary_key => :content_view_id, :foreign_key => :content_view_id
    has_many :repositories, :through => :content_view_repositories
    
    validates :name, :presence => true
    validates :organization, :presence => true

  end
end