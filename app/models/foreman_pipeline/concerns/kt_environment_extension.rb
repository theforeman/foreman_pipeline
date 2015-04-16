module ForemanPipeline
  module Concerns
    module KtEnvironmentExtension
      extend ActiveSupport::Concern

      included do
        has_many :job_to_environments, :class_name => 'ForemanPipeline::JobToEnvironment',
         :dependent => :destroy, :foreign_key => :to_environment_id
        has_many :jobs, :through => :job_to_environments, :class_name => 'ForemanPipeline::Job', :dependent => :nullify
      end
      
      def full_paths
        return [self.full_path] unless library?
        successors.map(&:full_path)
      end
    end
  end
end