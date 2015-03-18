module ForemanPipeline
  module Concerns
    module ComputeResourceExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'ForemanPipeline::Job', :inverse_of => :compute_resource
      end
    end
  end
end