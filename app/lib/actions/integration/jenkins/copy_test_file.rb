require 'tempfile'
require 'net/scp'
require 'uri'

module Actions
  module Integration
    module Jenkins
      class CopyTestFile < AbstractJenkinsAction
        def run
          test = ::Integration::Test.find input[:test_id]
          tmp = tmp_file test
          Net::SCP.upload!(remote_host(job.jenkins_instance),
                           "root", 
                           "/tmp/#{tmp.path.split("/").pop}",
                           "#{input.fetch(:jenkins_home)}/jobs/#{input.fetch(:name)}/workspace/#{filename(test, ".sh")}",
                           :ssh => { :password => "changeme"})          

        end

        def tmp_file(test)
          Tempfile.new([test.name, ".sh"], "/tmp") do |file|
            file.write(test.content)
          end 
        end

        def remote_host(jenkins_instance)
          URI(jenkins_instance.url).host
        end

        def filename(test, ext)
          [test.name, ext].join
        end
      end
    end
  end
end