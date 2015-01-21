module Integration
  module Glue::ElasticSearch::BaseModel

    def self.included(base)
      base.send :include, Katello::Ext::IndexedModel

      base.class_eval do
        index_options :extended_json => :extended_index_attrs,
                      :display_attrs => [:name]
        mapping do
          indexes :name, :type => 'string', :analyzer => :kt_name_analyzer
          indexes :name_sort, :type => 'string', :index => :not_analyzed
        end
      end
    end

    def extended_index_attrs
      {:name_sort => name.downcase}
    end
  end  
end