module Actions
  module ForemanPipeline
    module Job
      class SuspendUntilProvisioned < ::ForemanDeployments::Tasks::WaitUntilBuiltTaskDefinition::Action
        include ::Dynflow::Action::Cancellable
      end      
    end
  end
end