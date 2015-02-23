module Actions
  module Integration
    module Jenkins
      class CreateJenkinsMainJob < CreateJenkinsJob

        def run
          create_jenkins_job(input[:job_id],
                             input[:unique_name],
                             shell_command(input[:host_ip],
                                           job,
                                           input[:jenkins_home],
                                           input[:jenkins_instance_hostname]))
        end

        def shell_command(ip, job, jenkins_home, jenkins_instance_name)
          c = []
          c << "ssh-keyscan #{ip} >> #{jenkins_home}/.ssh/known_hosts;\n"
          c << "ssh -i #{jenkins_home}/.ssh/#{jenkins_instance_name} root@#{ip}"
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
          d.length == 1 ? "" : d.join(" ") 
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