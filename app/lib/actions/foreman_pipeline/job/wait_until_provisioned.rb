module Actions
  module ForemanPipeline
    module Job
      class WaitUntilProvisioned < Actions::Base
        include ::Dynflow::Action::Cancellable
        include ::Dynflow::Action::Polling

        def done?
          external_task[:build]
        end

        def timeout
          input[:timeout] || 2 * 60 * 60 # 2 hours default
        end

        def invoke_external_task
          schedule_timeout(timeout) unless timeout <= 0
          build_status
        end

        def poll_external_task
          fail(_("'%s' is a required parameter") % 'host_id') unless input.key?(:host_id)
          host = Host.find(input[:host_id])
          create_output(host)
          build_status(host)
        end

        def poll_interval
          30
        end

        def create_output(host)
          output[:host] = host
        end

        def build_status(host = nil)
          status = (!host.nil? && (host.reports.count > 1) && !host.reports.last.error?)
          { :build => status }
        end
      end
    end
  end
end
