module Actions
  module Integration
    module Mixins
      module UriExtension
        extend ActiveSupport::Concern
        require 'uri'

        def jenkins_hostname(job)
          URI(job.jenkins_instance.url).host  
        end
      end
    end
  end
end