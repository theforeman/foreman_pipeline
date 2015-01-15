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

                create_candlepin_key = plan_action(::Actions::Candlepin::ActivationKey::Create, :organization_label => job.content_view.organization.name) 
                create_key = plan_action(CreateActivationKey, :name => unique_hostname,
                                                              :organization_id => job.content_view.organization.id,
                                                              :environment_id => target_environment_id(job.content_view),
                                                              :content_view_id => job.content_view.id,
                                                              :cp_id => create_candlepin_key.output[:response][:id])

                plan_action(CreateHost, unique_hostname, job.hostgroup, job.compute_resource, { 
                               :org_id => job.content_view.organization.id,
                               :content_view_id => job.content_view.id,
                               :activation_key => create_key.output[:new_key]})

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

        def target_environment_id(content_view)
          cv_environment = content_view.content_view_environments.sort_by(&:created_at).last
          cv_environment.nil? ? nil : cv_environment.environment.id
        end

      end
    end
  end
end