module ForemanPipeline
  module Concerns
    module KtEnvironmentExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'ForemanPipeline::Job', :inverse_of => :kt_environment
      end
      
    end
  end
end