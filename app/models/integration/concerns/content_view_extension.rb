module Integration
  module Concerns
    module ContentViewExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'Integration::Job', :inverse_of => :content_view 
      end
            
    end
  end
end