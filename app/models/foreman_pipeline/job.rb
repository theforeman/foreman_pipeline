module ForemanPipeline
  class Job < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include Glue::ElasticSearch::Job
    include ForemanPipeline::Authorization::Job
    include ActiveModel::Validations

    belongs_to :content_view, :class_name => 'Katello::ContentView', :inverse_of => :jobs
    belongs_to :hostgroup, :class_name => '::Hostgroup', :inverse_of => :jobs
    belongs_to :organization
    belongs_to :compute_resource, :class_name => '::ComputeResource', :inverse_of => :jobs
    belongs_to :jenkins_instance, :class_name => "ForemanPipeline::JenkinsInstance"
    belongs_to :environment, :class_name => 'Katello::KTEnvironment'
    
    has_many :job_jenkins_projects, :dependent => :destroy
    has_many :jenkins_projects, :through => :job_jenkins_projects, :class_name => 'ForemanPipeline::JenkinsProject', :dependent => :restrict

    has_many :content_view_repositories, :class_name=> 'Katello::ContentViewRepository',
     :primary_key => :content_view_id, :foreign_key => :content_view_id
    has_many :repositories, :through => :content_view_repositories

    has_many :job_paths, :dependent => :destroy
    has_many :paths, :through => :job_paths, :class_name => 'Katello::KTEnvironment', :dependent => :nullify
    
    validates :name, :presence => true
    validates :organization, :presence => true
    validate :no_composite_view

    def is_valid?
      !self.attributes.values.include? nil
    end

    def target_cv_version_avail?
      !target_cv_version.nil?
    end

    def target_cv_version
      fail "Cannot fetch target version, no environment set" if environment.nil?
      fail "Cannot fetch target version, no content view set" if content_view.nil?
      self.environment.content_view_versions.where(:content_view_id => self.content_view.id).first
    end

    def init_run
      fail "Cannnot contact Jenkins server: no Jenkins Instance set for the job: #{name}" if jenkins_instance.nil?
      fail "Cannot log in to Jenkins server:
            no Jenkins User set for the Jenkins Instance: #{jenkins_instancej.name}" if jenkins_instance.jenkins_user.nil? 
      jenkins_instance.create_client(jenkins_instance.jenkins_user.name, jenkins_instance.jenkins_user.token)
    end

    def version_already_promoted?
      self.target_cv_version.environments.include?(self.environment.successor)
    end

    private

    def no_composite_view
      errors.add(:base,
       "Cannot add content view, only non-composites allowed.") if !content_view.nil? && content_view.composite?
    end
    
  end
end