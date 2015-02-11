module Actions
  module Integration
    module Job
      class CreateHost < Actions::Staypuft::Host::Create
        
        def run                     
          hostgroup = Hostgroup.find(input[:hostgroup_id])
          host = ::Host::Managed.new(
                    name:                 input[:name],
                    hostgroup_id:         input[:hostgroup_id],
                    build:                true, 
                    managed:              true,
                    enabled:              true,
                    environment:          hostgroup.environment,
                    compute_resource_id:  input.fetch(:compute_resource_id),
                    compute_attributes:   input[:compute_attributes],
                    organization_id:      input[:options][:org_id],
                    location:             Location.find_by_name("promotions") || Location.create({:name => "promotions"})
                  )

          organization_param
          keys_param
          
          host.save!
          jenkins_pubkey_param_for host
          host.power.start if input.fetch(:options).fetch(:start)

          output.update host: { id: host.id,
                                name: host.name,
                                ip: host.ip,
                                mac: host.mac,
                                params: host.params }            
        end

        private

        def kt_org           
           ::Organization.find(input[:options][:org_id]).name      
        end

        def organization_param
          org_cp = ::CommonParameter.find_by_name('kt_org')
          if org_cp.nil?
            ::CommonParameter.create(:name => 'kt_org', :value => kt_org)
          else
            org_cp.update_attributes(:value => kt_org)
          end                            
        end

        def keys_param
          keys_cp = ::CommonParameter.find_by_name('kt_activation_keys')
          if keys_cp.nil?
            ::CommonParameter.create(:name => 'kt_activation_keys', :value => input[:options][:activation_key][:name])
          else
            keys_cp.update_attributes(:value => input[:options][:activation_key][:name])
          end                            
        end

        def jenkins_pubkey
          ::Integration::JenkinsInstance.find(input.fetch(:options).fetch(:jenkins_instance_id)).pubkey
        end

        def jenkins_pubkey_param_for(host)
          ::HostParameter.create(:name => 'integration_jenkins_pubkey', :value => jenkins_pubkey, :host => host)
        end

      end
    end
  end
end