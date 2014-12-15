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

          host.params['kt_org'] = kt_org
          host.params['kt_activation_keys'] = kt_activation_keys(target_environment)
          binding.pry
          # host.save!
          # host.power.start if input.fetch(:options).fetch(:start)

           # output.update host: { id: host.id,
           #                      name: host.name,
           #                      ip: host.ip,
           #                      mac: host.mac }            
        end

        private

        def kt_org           
           ::Organization.find(input[:options][:org_id]).name      
        end                  
      end
    end
  end
end