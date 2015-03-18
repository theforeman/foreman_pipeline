module Actions
  module ForemanPipeline
    module Job
      class CvPromoteJobHook < JobHook

        def self.subscribe
          Katello::ContentView::Promote
        end

        def plan(version, environment, is_force = false)          
          valid_jobs = version.content_view.jobs.select { |job| job.is_valid? }
          jobs_to_run = valid_jobs.select { |job| version.eql? job.target_cv_version }
          allowed_jobs = jobs_to_run.select { |job| job.levelup_trigger && !job.version_already_promoted? }
          
          plan_self(:trigger => trigger.output,
                    :job_ids => allowed_jobs.map(&:id),
                    :job_names => allowed_jobs.map(&:name))    
        end        
      end
    end
  end
end