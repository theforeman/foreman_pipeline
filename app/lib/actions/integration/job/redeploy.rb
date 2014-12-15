module Actions
  module Integration
    module Job
      class Redeploy < Actions::EntryAction     

        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo)
          plan_self(:trigger => trigger.output)
          repo.jobs.each do |job|
            
            if !job.hostgroup.nil? && !job.compute_resource.nil? && !job.content_view.nil?         
              sequence do
                unique_hostname = "#{normalize_name repo.name}-#{::Katello::Util::Model.uuid}"

                # new_key = new_activation_key(job.content_view, target_environment(job.content_view), repo)
                # binding.pry
                prepare_activation_key = plan_action(::Actions::Candlepin::ActivationKey::Create, :organization_label => job.content_view.organization.name) 
                create_key = plan_action(CreateActivationKey, :name => unique_hostname,
                                                              :organization_id => job.content_view.organization.id,
                                                              :environment_id => target_environment_id(job.content_view),
                                                              :content_view_id => job.content_view.id,
                                                              :cp_id => prepare_activation_key.output[:response][:id])
                # plan_action(CreateHost, 
                #             unique_hostname,
                #             job.hostgroup,
                #             job.compute_resource, {
                #                org_id => job.content_view.organization.id,
                #                content_view_id => job.content_view.id})

                plan_action(Dummy, :job => job)
              end

            end            
          end
        end

        def run              
        end

        private

        def normalize_name(repo_name)
          repo_name.sub(/[^a-z0-9\-]/, '-')
        end

        def new_activation_key(content_view, environment, repo)
          ::Katello::ActivationKey.new(
                        name:             "key-for-#{repo.name}",
                        organization_id:   content_view.organization.id,
                        environment_id:    environment.nil? ? nil : environment.id,
                        content_view_id:   content_view.id,
                        user_id:           User.current.id 
                      )
        end

        def target_environment(content_view)
          cv_environment = content_view.content_view_environments.sort_by(&:created_at).last
          cv_environment.nil? ? nil : cv_environment.environment
        end

        def target_environment_id(content_view)
          cv_environment = content_view.content_view_environments.sort_by(&:created_at).last
          cv_environment.nil? ? nil : cv_environment.environment.id
        end

      end
    end
  end
end