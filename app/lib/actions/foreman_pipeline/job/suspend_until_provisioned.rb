module Actions
  module ForemanPipeline
    module Job
      class SuspendUntilProvisioned < ::ForemanDeployments::Tasks::WaitUntilBuiltTaskDefinition::Action
        include ::Dynflow::Action::Cancellable

        def done?
          output[:task][:build]
        end
      end
    end
  end
end