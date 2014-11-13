module Actions
  module Integration
    module Job
      class RedeployHelper < Actions::EntryAction

        def plan(trigger)
          plan_self(:trigger => trigger)
        end
        
        def run
          output[:sync_succ] = sync_succ?
        end

        def sync_succ?          
          input[:trigger][:sync_result][:pulp_tasks].all? {|task| task[:state] == "finished" && task[:result][:result] == "success"}          
        end

      end
    end
  end
end