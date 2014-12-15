module Actions
  module Integration
    module Job
      class PrepareActivationKey < ::Actions::EntryAction
        
        def plan
          plan_self
          # TODO? think about key presence checking before creation w/o conditional planning
          # plan_action(::Actions::Candlepin::ActivationKey::Create, self.output[:new_key]) if self.output[:new_key]
        end

        def run         
          content_view = ::Katello::ContentView.find(input[:content_view_id])
          environment = target_environment(content_view)

          found_key = find_existing_key(environment, content_view)
          if found_key
            output[:activation_key_id] = found_key.id
          else
            output[:new_key] = ::Katello::ActivationKey.new(
                        name:             "key-for-#{input[:name]}",
                        organization_id:   content_view.organization.id,
                        environment_id:    environment.id,
                        content_view_id:   content_view.id,
                        user_id:           User.current.id 
                      )
          end
        end

        private

        def find_existing_key(environment, content_view)
          ::Katello::ActivationKey.where({
            organization_id:   content_view.organization.id,
            environment_id:    environment.nil? ? nil : environment.id,
            content_view_id:   content_view.id
          }).first          
        end      

        def target_environment(content_view)
          cv_environment = content_view.content_view_environments.sort_by(&:created_at).last
          cv_environment.nil? ? nil : cv_environment.environment
        end
      end
    end
  end
end