module ForemanPipeline
  module Concerns
    module KtEnvironmentExtension
      extend ActiveSupport::Concern

      included do
        has_many :job_paths, :class_name => 'ForemanPipeline::JobPath', :dependent => :destroy, :foreign_key => :path_id
        has_many :jobs, :through => :job_paths, :class_name => 'ForemanPipeline::Job'
      end
      
    end
  end
end