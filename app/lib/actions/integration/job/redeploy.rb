module Actions
  module Integration
    module Job
      class Redeploy < Actions::EntryAction     

        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo) 

          plan_self(:trigger => trigger.output)

          sequence do
          check_sync_succ = plan_action(RedeployHelper, self.input[:trigger])                 
          
            if check_sync_succ.output[:sync_succ]
              concurrence do              
                 repo.jobs.each do |job|
                  plan_action(Dummy, :job => job)                  
                 end
              end
            end
          end
        end

        def run              
        end

      end
    end
  end
end