module Actions
  module ForemanPipeline
    module Job
      class SuspendUntilProvisioned < Actions::Staypuft::Host::WaitUntilProvisioned

      include ::Dynflow::Action::Cancellable

      def plan(host_id)
        plan_self :host_id => host_id
      end

      def run(event = nil)
        super event
      end

      end      
    end
  end
end