require 'net/ssh'
require 'uri'

module Actions
  module ForemanPipeline
    module JenkinsInstance
      class AbstractJenkinsInstanceAction < Actions::EntryAction
        include Mixins::SshExtension

        def parse_jenkins_hostname
          URI(input.fetch(:jenkins_url)).host
        end
      end
    end
  end
end