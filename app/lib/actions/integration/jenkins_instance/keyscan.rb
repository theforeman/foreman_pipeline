module Actions
  module Integration
    module JenkinsInstance
      class Keyscan < AbstractJenkinsInstanceAction
        def run
          output[:status] = do_keyscan(parse_jenkins_hostname)
        end

        def do_keyscan(host)
          ip = Socket::getaddrinfo(host, 'www', nil, Socket::SOCK_STREAM)[0][3]
          status = nil

          Net::SSH.start(ip, 'root', :keys => [input.fetch(:cert_path)]) do |ssh|
            status = ssh_exec!(ssh, "ssh-keyscan #{input[:host_ip]} >> #{input[:jenkins_home]}/.ssh/known_hosts;\n")[2]
          end
          status
        end
      end
    end
  end
end