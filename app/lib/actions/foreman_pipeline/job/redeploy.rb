module Actions
  module ForemanPipeline
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

            
            # suspend_until = plan_action(SuspendUntilProvisioned, create_host.output[:host][:id])
            suspend_until = plan_action(::ForemanDeployments::Tasks::WaitUntilBuiltTaskDefinition, 'host_id' => create_host.output[:host][:id])

            plan_self(:create_host => create_host.output[:host],
                      :installed_at => suspend_until.output[:installed_at],
                      :new_key => create_key.output[:new_key])
            
          end
        end

        def run
          output[:host] = input[:create_host]
          output[:activation_key] = input[:new_key]
        end

        private

        def normalize_name(repo_name)
          repo_name.gsub(/[^a-z0-9\-]/, '-')
        end

      end
    end
  end
end