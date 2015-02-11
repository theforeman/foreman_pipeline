module Actions
  module Integration
    module Job
      class Redeploy < Actions::EntryAction

        def plan(job)                 
          sequence do
            unique_hostname = "#{normalize_name job.name}-#{::Katello::Util::Model.uuid}"

            create_candlepin_key = plan_action(::Actions::Candlepin::ActivationKey::Create, :organization_label => job.content_view.organization.name) 
            create_key = plan_action(CreateActivationKey, :name => unique_hostname,
                                                          :organization_id => job.content_view.organization.id,
                                                          :environment_id => job.environment_id,
                                                          :content_view_id => job.content_view.id,
                                                          :cp_id => create_candlepin_key.output[:response][:id])

            create_host = plan_action(CreateHost, unique_hostname, job.hostgroup, job.compute_resource, { 
                           :org_id => job.content_view.organization.id,
                           :content_view_id => job.content_view.id,
                           :activation_key => create_key.output[:new_key],
                           :jenkins_instance_id => job.jenkins_instance_id})

            
            plan_action(SuspendUntilProvisioned, create_host.output[:host][:id])

            plan_self(:create_host => create_host.output[:host])
            
          end
        end

        def run
          output = input[:create_host]
        end

        private

        def normalize_name(repo_name)
          repo_name.gsub(/[^a-z0-9\-]/, '-')
        end

      end
    end
  end
end