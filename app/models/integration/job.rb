module Integration
  class Job < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::Job
    include Integration::Authorization::Job
    include ActiveModel::Validations

    belongs_to :content_view, :class_name => 'Katello::ContentView', :inverse_of => :jobs
    belongs_to :hostgroup, :class_name => '::Hostgroup', :inverse_of => :jobs
    belongs_to :organization
    belongs_to :compute_resource, :class_name => '::ComputeResource', :inverse_of => :jobs
    belongs_to :jenkins_instance, :inverse_of => :jobs
    belongs_to :environment, :class_name => 'Katello::KTEnvironment', :inverse_of => :jobs

    # rubocop:disable HasAndBelongsToMany
    has_and_belongs_to_many :tests, :join_table => :integration_jobs_tests

    has_many :content_view_repositories, :class_name=> 'Katello::ContentViewRepository',
     :primary_key => :content_view_id, :foreign_key => :content_view_id
    has_many :repositories, :through => :content_view_repositories
    
    validates :name, :presence => true
    validates :organization, :presence => true
    validate :no_composite_view

    def no_composite_view
      errors.add(:base,
       "Cannot add content view, only non-composites allowed.") if !content_view.nil? && content_view.composite?
    end

    def is_valid?
      !self.attributes.values.include? nil
    end

    def target_cv_version_avail?
      !target_cv_version.nil?
    end

    def target_cv_version
      self.environment.content_view_versions.joins(:content_view)
        .where("#{Katello::ContentViewVersion.table_name}.content_view_id = #{self.content_view_id}").first
    end

    def init_run
      jenkins_instance.create_client
    end

    
  end
end