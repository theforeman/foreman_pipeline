module ForemanPipeline
  module Concerns
    module ApiControllerExtensions
      extend ActiveSupport::Concern

      def resource_class
        @resource_class ||= resource_name.classify.constantize
      rescue NameError
        @resource_class ||= "ForemanPipeline::#{resource_name.classify}".constantize
      end
    end
  end
end
