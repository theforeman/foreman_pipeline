module Actions
  module ForemanPipeline
    module Jenkins
      class GetVersion < Actions::EntryAction
        
        def run
          instance = ::ForemanPipeline::JenkinsInstance.find input[:id]
          output[:version] = instance.create_client.get_jenkins_version
        end

        def humanized_name
          "Get Jenkins CI version: %s" % input[:name]
        end
      end
    end
  end
end