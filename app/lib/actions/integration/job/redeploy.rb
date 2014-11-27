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
            plan_action(Dummy, :job => job)
            plan_action(RedeployHost, "#{repo.name}.#{SecureRandom.uuid}",
                                       job.hostgroup,
                                       job.compute_resource)
          end
        end

        def run              
        end

      end
    end
  end
end