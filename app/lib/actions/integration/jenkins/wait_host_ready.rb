module Actions
  module Integration
    module Jenkins
      class WaitHostReady < EntryAction
        include Dynflow::Action::Polling
        include Dynflow::Action::Cancellable
        include Mixins::SshExtension

        def external_task
          output[:result]
        end

        def done?
          external_task
        end

        private

        def invoke_external_task
          nil
        end

        def external_task=(external_task_data)
          output[:result] = external_task_data
        end

        def poll_external_task
          status = nil
          ip = Socket::getaddrinfo(input[:jenkins_instance_hostname], 'www', nil, Socket::SOCK_STREAM)[0][3]          
          Net::SSH.start(ip, 'root', :password => "changeme") do |ssh|
            status = ssh_exec!(ssh, command)
          end
          status[2].to_i == 0
        end

        def command
          c = []
          c << "sudo -u jenkins ssh -i #{input[:jenkins_home]}/.ssh/#{input[:jenkins_instance_hostname]} -o StrictHostKeyChecking=no root@#{input[:host_ip]}"
          c << "'echo"
          c << echo
          c << "'"
          c.join(" ")
        end

        def echo
          '"host ready yet?"'
        end

        def poll_interval
          5
        end

      end
    end
  end
end