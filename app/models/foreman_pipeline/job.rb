module ForemanPipeline
  class Job < Katello::Model
    self.include_root_in_json = false

    include Katello::Glue
    include ForemanPipeline::Authorization::Job
    include ActiveModel::Validations

    belongs_to :content_view, :class_name => 'Katello::ContentView', :inverse_of => :jobs
    belongs_to :hostgroup, :class_name => '::Hostgroup', :inverse_of => :jobs
    belongs_to :organization
    belongs_to :compute_resource, :class_name => '::ComputeResource', :inverse_of => :jobs
    belongs_to :jenkins_instance, :class_name => "ForemanPipeline::JenkinsInstance"
    belongs_to :environment, :class_name => 'Katello::KTEnvironment'

    has_many :job_jenkins_projects, :dependent => :destroy
    has_many :jenkins_projects, :through => :job_jenkins_projects, :class_name => 'ForemanPipeline::JenkinsProject'
    has_many :content_view_repositories, :class_name=> 'Katello::ContentViewRepository',
     :primary_key => :content_view_id, :foreign_key => :content_view_id
    has_many :repositories, :through => :content_view_repositories

    has_many :job_to_environments, :class_name => 'ForemanPipeline::JobToEnvironment', :dependent => :destroy
    has_many :to_environments, :through => :job_to_environments, :class_name => 'Katello::KTEnvironment', :dependent => :nullify

    validates :name, :presence => true
    validates :organization, :presence => true
    validate :no_composite_view, :env_succession, :compute_resource_on_hg, :compute_profile_on_hg

    attr_accessible :name, :content_view_id, :hostgroup_id, :organization_id, :compute_resource_id, :jenkins_instance_id,
      :environment_id, :manual_trigger, :levelup_trigger, :sync_trigger, :content_view, :hostgroup, :organization, :compute_resource,
      :jenkins_instance, :environment, :to_environments

    scoped_search :on => :name, :complete_value => true
    scoped_search :on => :organization_id, :complete_value => true
    scoped_search :on => :manual_trigger, :complete_value => true
    scoped_search :on => :levelup_trigger, :complete_value => true
    scoped_search :on => :sync_trigger, :complete_value => true

    def is_valid?
      !self.attributes.values.include?(nil) && !self.jenkins_instance.jenkins_user.nil?
    end

    def target_cv_version_avail?
      !target_cv_version.nil?
    end

    def target_cv_version
      fail "Cannot fetch target version, no environment set" if environment.nil?
      fail "Cannot fetch target version, no content view set" if content_view.nil?
      fail "Content view has no versions!" if content_view.content_view_versions.empty?
      self.environment.content_view_versions.where(:content_view_id => self.content_view.id).first
    end

    def init_run
      fail "Cannnot contact Jenkins server: no Jenkins Instance set for the job: #{name}" if jenkins_instance.nil?
      fail "Cannot log in to Jenkins server: no Jenkins User set for the Jenkins Instance: #{jenkins_instance.name}" if jenkins_instance.jenkins_user.nil?
      jenkins_instance.create_client(jenkins_instance.jenkins_user.name, jenkins_instance.jenkins_user.token)
    end

    #Is any to_env set? (Do we want to promote to any env?)
    def should_be_promoted?
      !to_environments.empty?
    end

    # this shlould make sure not to trigger cyclic runs in hook actions
    def not_yet_promoted?
      # no to_envs means we do not want to promote, no need to check further here
      return true if to_environments.empty?
      #we want to promote, but are any of to_envs safe to promote to?
      can_be_promoted?
    end

    #If we want to promote, is it safe (or could we get a cycle)?
    def promotion_safe?
      should_be_promoted? ? can_be_promoted? : false
    end

    #we have some to_envs set (== we want to promote), but cv version may already be in those envs
    def envs_for_promotion
      to_environments.reject { |env| target_cv_version.environments.include?(env) }
    end

    def can_be_promoted?
      !envs_for_promotion.empty?
    end

    def available_compute_resources
      # ids = ComputeAttribute.where(:compute_profile_id => hostgroup.compute_profile_id).map(&:compute_resource_id)
      # ComputeResource.where(:id => ids)
      hostgroup.compute_profile.compute_attributes.map(&:compute_resource) rescue []
    end

    private

    def no_composite_view
      errors.add(:base,
       "Cannot add content view, only non-composites allowed.") if !content_view.nil? && content_view.composite?
    end

    def env_succession
      if environment && should_be_promoted?
        to_environments.each do |to_env|
          unless to_env.prior == environment
            errors.add(:base, "Environment succession violation: #{to_env.name}")
          end
        end
      end
    end

    def compute_profile_on_hg
      errors.add(:base,
        "Cannot add Hostgroup without Compute Profile") if hostgroup && hostgroup.compute_profile.nil?
    end

    def compute_resource_on_hg
      if hostgroup && compute_resource && !available_compute_resources.include?(compute_resource)
        errors.add(:base,
          "Cannot add a Compute resource that is not associated with assigned Hostgroup through a Compute profile")
      end
    end
  end
end
