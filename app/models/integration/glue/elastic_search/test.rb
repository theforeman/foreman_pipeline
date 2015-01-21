module Integration
  module Glue::ElasticSearch::Test

    def self.included(base)
      base.class_eval do
        include Glue::ElasticSearch::BaseModel        
      end
    end
    
  end
end