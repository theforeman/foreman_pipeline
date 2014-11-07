module Integration
  module Concerns
    module ContentViewRepositoryExtension
      extend ActiveSupport::Concern

      included do
        belongs_to :job, :class_name => 'Integration::Job', :foreign_key => :content_view_id, :primary_key => :content_view_id        
      end
      
    end
  end  
end