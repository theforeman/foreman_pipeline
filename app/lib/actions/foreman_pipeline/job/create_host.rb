module Actions
  module ForemanPipeline
    module Job
      class CreateHost < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def plan(name, hostgroup, compute_resource, options = {})
          compute_attributes = hostgroup.compute_profile.compute_attributes
                                .where(compute_resource_id: compute_resource.id)
                                .first.vm_attrs

          plan_self name:               name,
                    hostgroup_id:       hostgroup.id,
                    compute_attributes: compute_attributes,
                    options:            options
          input.update compute_resource_id: compute_resource.id if compute_resource
        end

        def run
          hostgroup = Hostgroup.find(input[:hostgroup_id])
          location = Location.where(:name => "foreman_pipeline").first
          host = ::Host::Managed.new(
                    name:                 input[:name],
                    hostgroup:            hostgroup,
                    build:                true,
                    managed:              true,
                    enabled:              true,
                    environment:          hostgroup.environment,
                    compute_resource_id:  input.fetch(:compute_resource_id),
                    compute_attributes:   input[:compute_attributes],
                    puppet_proxy:         hostgroup.puppet_proxy,
                    puppet_ca_proxy:      hostgroup.puppet_ca_proxy,
                    organization_id:      input[:options][:org_id],
                    location:             location
                  )

          organization_param
          keys_param

          host.save!
          jenkins_pubkey_param_for host
          host.power.start

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
          ::ForemanPipeline::JenkinsInstance.find(input.fetch(:options).fetch(:jenkins_instance_id)).pubkey
        end

        def jenkins_pubkey_param_for(host)
          ::HostParameter.create(:name => 'pipeline_jenkins_pubkey', :value => jenkins_pubkey, :reference_id => host.id)
        end
      end
    end
  end
end