module Integration
  module Concerns
    module RepositoryExtension
      extend ActiveSupport::Concern

      included do
        has_many :jobs, :class_name => 'Integration::Job', :source => :job, :through => :content_view_repositories     
      end

    end
  end   
end