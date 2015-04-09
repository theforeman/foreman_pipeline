module ForemanPipeline
  module Concerns
    module KtEnvironmentExtension
      extend ActiveSupport::Concern

      included do
        has_many :job_to_environments, :class_name => 'ForemanPipeline::JobToEnvironment',
         :dependent => :destroy, :foreign_key => :to_environment_id
        has_many :jobs, :through => :job_to_environments, :class_name => 'ForemanPipeline::Job'
      end
      
    end
  end
end