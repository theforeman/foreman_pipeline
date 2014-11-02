module Integration
  class Test < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::Test
    include Integration::Authorization::Test

    validates :name, :presence => true
    validates :organization, :presence => true

    belongs_to :organization
    has_and_belongs_to_many :jobs, :join_table => :integration_jobs_tests
  end
end