module ForemanPipeline
  module Concerns
    module ContentViewExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'ForemanPipeline::Job', :inverse_of => :content_view, :dependent => :nullify
      end

    end
  end
end