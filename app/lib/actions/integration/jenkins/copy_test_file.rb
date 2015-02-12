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
          Net::SCP.upload!(jenkins_hostname(job),
                           "root", 
                           "/tmp/#{tmp.path.split("/").pop}",
                           "#{input.fetch(:jenkins_home)}/jobs/#{input.fetch(:name)}/workspace/#{filename(test, ".sh")}",
                           :ssh => { :password => "changeme"})          
          
          #try something like this and get rid of tmp file??
          # Net::SSH.start(ip, 'root', :password => passwd) do |ssh|
          #   ssh.scp.upload! "#{key_location}/#{parse_host}.pub", buffer
          # end


        end

        def tmp_file(test)
          Tempfile.new([test.name, ".sh"], "/tmp") do |file|
            file.write(test.content)
          end 
        end

        def filename(test, ext)
          [test.name, ext].join
        end
      end
    end
  end
end