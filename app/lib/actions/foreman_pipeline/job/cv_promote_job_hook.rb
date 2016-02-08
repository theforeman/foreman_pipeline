module Actions
  module ForemanPipeline
    module Job
      class CvPromoteJobHook < JobHook

        def self.subscribe
          Katello::ContentView::Promote
        end

        def plan(version, environment, is_force = false)
          allowed_jobs = filter.allowed_jobs_for_cvv version

          plan_self(:trigger => trigger.output,
                    :job_ids => allowed_jobs.map(&:id),
                    :job_names => allowed_jobs.map(&:name))
        end
      end
    end
  end
end