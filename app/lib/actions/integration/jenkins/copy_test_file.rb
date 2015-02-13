require 'tempfile'
require 'net/scp'
require 'uri'

module Actions
  module Integration
    module Jenkins
      class CopyTestFile < AbstractJenkinsAction
        include Mixins::UriExtension

        def run
          test = ::Integration::Test.find input[:test_id]
          tmp = tmp_file test          

          Net::SSH.start(jenkins_hostname(job), 'root', :keys => [input.fetch(:cert_path)]) do |ssh|
            ssh.scp.upload! "/tmp/#{tmp.path.split("/").pop}", workspace_path(test)
            ssh.exec! "chown jenkins:jenkins #{workspace_path(test)}"
          end
          output[:content] = test.content
          output[:tmp_filepath] = "/tmp/#{tmp.path.split("/").pop}"
        end

        def tmp_file(test)
          file = Tempfile.new(test.name, "/tmp")
          file.write(test.content)
          file.rewind
          file
        end

        def workspace_path(test)
          [input.fetch(:jenkins_home), "jobs", input.fetch(:name), "workspace", test.name].join("/")
        end
      end
    end
  end
end