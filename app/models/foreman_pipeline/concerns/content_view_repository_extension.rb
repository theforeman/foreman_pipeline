module ForemanPipeline
  module Concerns
    module ContentViewRepositoryExtension
      extend ActiveSupport::Concern

      included do
        belongs_to :job, :class_name => 'ForemanPipeline::Job', :foreign_key => :content_view_id, :primary_key => :content_view_id        
      end
      
    end
  end  
end