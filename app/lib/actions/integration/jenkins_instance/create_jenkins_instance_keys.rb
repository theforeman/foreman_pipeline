require 'net/ssh'
require 'net/scp'
require 'uri'

module Actions
  module Integration
    module JenkinsInstance
      class CreateJenkinsInstanceKeys < EntryAction
        
        def run
          output[:pubkey] = fetch_pubkey(parse_host, input[:passwd])
        end

        def parse_host
          URI(input.fetch(:url)).host
        end

        def fetch_pubkey(host, passwd)
          buffer = StringIO.new          
          ip = Socket::getaddrinfo(host, 'www', nil, Socket::SOCK_STREAM)[0][3]
          Net::SSH.start(ip, 'root', :password => passwd) do |ssh|
            status = ssh_exec!(ssh, "ls #{key_location}")[2]           
            ssh.exec! "mkdir #{key_location}" if status > 0
            ssh.exec! "sed -i s:Defaults\\.*requiretty:#Defaults\\ requiretty:g /etc/sudoers"
            ssh.exec! "sudo -u jenkins ssh-keygen -f #{key_location}/#{parse_host} -t rsa -N '' -q"
            ssh.scp.download! "#{key_location}/#{parse_host}.pub", buffer
          end          
          buffer.string
        end

         # http://stackoverflow.com/questions/3386233/how-to-get-exit-status-with-rubys-netssh-library
        def ssh_exec!(ssh, command)
          stdout_data = ""
          stderr_data = ""
          exit_code = nil
          exit_signal = nil
          ssh.open_channel do |channel|
            channel.exec(command) do |ch, success|
              unless success
                abort "FAILED: couldn't execute command (ssh.channel.exec)"
              end
              channel.on_data do |ch, data|
                stdout_data += data
              end

              channel.on_extended_data do |ch, type, data|
                stderr_data += data
              end

              channel.on_request("exit-status") do |ch, data|
                exit_code = data.read_long
              end

              channel.on_request("exit-signal") do |ch, data|
                exit_signal = data.read_long
              end
            end
          end
          ssh.loop
          [stdout_data, stderr_data, exit_code, exit_signal]

        end

        def key_location
          "#{jenkins_home}/.ssh"
        end

        def jenkins_home
          home = input.fetch(:jenkins_home)
          home.end_with?('/') ? home.chop : home
        end

      end
    end
  end
end