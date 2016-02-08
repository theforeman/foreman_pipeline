module Actions
  module ForemanPipeline
    module Job
      class CvPublishJobHook < JobHook

        def self.subscribe
          Katello::ContentView::Publish
        end

        def plan(content_view, descripton)
          allowed_jobs = filter.allowed_jobs_for_cv content_view

          plan_self(:trigger => trigger.output,
                    :job_ids => allowed_jobs.map(&:id),
                    :job_names => allowed_jobs.map(&:name))
        end
      end
    end
  end
end