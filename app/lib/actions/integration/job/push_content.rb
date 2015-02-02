module Actions
  module Integration
    module Job
      class PushContent < Actions::EntryAction

        def run
          job = ::Integration::Job.find input[:job_id]
          host = ::Host::Managed.find 62
          job.init_run
          job.jenkins_instance.client.job.create_freestyle(:name => host.name, 
                                                           :shell_command => shell_command(host.ip, job))
          job.jenkins_instance.client.job.build host.name
        end

        def shell_command(ip, job)
          root_pass = "changeme"
          c = []
          # keys do not work for unknown reason
          # c << 'ssh-keygen -t rsa -N "" -f id_rsa'
          # c << "cat ./id_rsa.pub | sshpass -p #{root_pass} ssh root@#{ip} 'mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys'"
          c << "sshpass -p #{root_pass} ssh -o StrictHostKeyChecking=no root@#{ip}"
          c << "'"    
          c << add_repo_sources(job)
          c << ";"
          c << install_packages
          c << "'"
          c.join(" ")
        end

        def add_repo_sources(job)
          d = []
          job.repositories.each do |repo|
            d << "echo #{repos_d(repo, job)} > /etc/yum.repos.d/#{repo.name}.repo"            
          end
          d.join(";")
        end

        def install_packages
          d = ["yum -y install"]
          input[:package_names].each { |packagename| d << "#{packagename}" }
          d.join(" ")
        end

        def repos_d(repo, job)
          c = []
          c << '"'
          c << "[#{repo.name}]"
          c << "name=#{repo.name}"
          c << "baseurl=#{::Setting[:foreman_url]}/pulp/repos/#{job.organization.name}/#{job.environment.name}/#{job.content_view.name}/custom/#{repo.product.name}/#{repo.name}"
          c << "enabled=1"
          c << "gpgcheck=0"
          c << '"'
          c.join("\n")
        end


      end
    end
  end
end