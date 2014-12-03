require 'securerandom'
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
            
            if !job.hostgroup.nil? && !job.compute_resource.nil?              
              sequence do
                plan_action(CreateHost, 
                            "#{normalize_name repo.name}-#{SecureRandom.uuid}",
                             job.hostgroup,
                             job.compute_resource,
                             {:org_id => job.content_view.organization.id})
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

      end
    end
  end
end