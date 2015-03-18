module ForemanPipeline
  module Glue::ElasticSearch::JenkinsProject

    def self.included(base)
      base.class_eval do
        include Glue::ElasticSearch::BaseModel        
      end
    end
    
  end  
end