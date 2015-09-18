require 'net/ssh'
require 'net/scp'
require 'uri'

module Actions
  module ForemanPipeline
    module JenkinsInstance
      class CreateJenkinsInstanceKeys < AbstractJenkinsInstanceAction

        def run
          output[:pubkey] = fetch_pubkey(parse_jenkins_hostname)
        end

        def fetch_pubkey(host)
          buffer = StringIO.new
          ip = Socket::getaddrinfo(host, 'www', nil, Socket::SOCK_STREAM)[0][3]

          Net::SSH.start(ip, 'root', :keys => [input.fetch(:cert_path)]) do |ssh|
            status = ssh_exec!(ssh, "ls #{key_location}")[2]
            ssh.exec!("mkdir #{key_location}") if status > 0
            ssh.exec! "sed -i s:Defaults\\.*requiretty:#Defaults\\ requiretty:g /etc/sudoers"
            ssh.exec! "rm -f #{key_location}/#{parse_jenkins_hostname}.pub #{key_location}/#{parse_jenkins_hostname}"
            ssh.exec! "sudo -u jenkins ssh-keygen -f #{key_location}/#{parse_jenkins_hostname} -t rsa -N '' -q"
            ssh.scp.download! "#{key_location}/#{parse_jenkins_hostname}.pub", buffer
          end

          buffer.string
        end

        def key_location
          "#{input.fetch(:jenkins_home)}/.ssh"
        end

        def finalize
          if output[:pubkey].match(/^ssh-rsa/)
            output[:status] = 0
          else
            output[:status] = 1
          end
        end

      end
    end
  end
end