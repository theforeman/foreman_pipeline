module ForemanPipeline
  module Concerns
    module KtEnvironmentExtension
      extend ActiveSupport::Concern

      included do
        has_many :job_paths, :class_name => 'ForemanPipeline::JobPath', :dependent => :destroy, :foreign_key => :path_id
        has_many :jobs, :through => :job_paths, :class_name => 'ForemanPipeline::Job'
      end

      # def immediate_cussessors
      #   return self.successor unless self.library?
      #   self.organization.promotion_paths.empty? ? [] : self.organization.promotion_paths.map {|path| path[0]} 
      # end

      def full_paths
        return [self.full_path] unless self.library?
        self.organization.promotion_paths
      end
      
    end
  end
end