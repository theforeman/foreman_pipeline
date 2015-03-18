module ForemanPipeline
  module Concerns
    module HostgroupExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'ForemanPipeline::Job', :inverse_of => :hostgroup        
      end
      
    end
  end
end