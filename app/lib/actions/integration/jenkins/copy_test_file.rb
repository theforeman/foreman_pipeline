require 'tempfile'
require 'net/scp'
require 'uri'

module Actions
  module Integration
    module Jenkins
      class CopyTestFile < Actions::EntryAction
        def run
          test = ::Integration::Test.find input[:test_id]
          job = ::Integration::Job.find input[:job_id]
          tmp = tmp_file test
          Net::SCP.upload!(remote_host(job.jenkins_instance), "root", 
                          "/home/oprazak/tmp/#{tmp.path.split("/").pop}",
                          "/var/lib/jenkins/jobs/#{input[:name]}/workspace/#{filename(test.name, ".sh")}",
                          :ssh => { :password => "changeme"})          

        end

        def tmp_file(test)
          Tempfile.new([test.name, ".sh"], "/home/oprazak/tmp") do |file|
            file.write(test.content)
          end 
        end

        def remote_host(jenkins_instance)
          URI(jenkins_instance.url).host
        end

        def filename(test_name, ext)
          [test_name, ext].join
        end
      end
    end
  end
end