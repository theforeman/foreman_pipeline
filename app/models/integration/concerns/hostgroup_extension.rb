module Integration
  module Concerns
    module HostgroupExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'Integration::Job', :inverse_of => :hostgroup        
      end
      
    end
  end
end