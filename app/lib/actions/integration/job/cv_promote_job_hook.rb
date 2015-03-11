module Actions
  module Integration
    module Job
      class CvPromoteJobHook < Actions::EntryAction

        def self.subscribe
          Katello::ContentView::Promote
        end

        def plan(version, environment, is_force = false)          
          

          valid_jobs = version.content_view.jobs.select { |job| job.is_valid? }
          jobs_to_run = valid_jobs.select { |job| version.eql? job.target_cv_version }        
          jobs_to_run.each do |job|
            
            if job.levelup_trigger && !job.version_already_promoted?
              plan_self(:trigger => trigger.output, :job_id => job.id)    
            end

          
          end
        end

        def run
          job = ::Integration::Job.find input[:job_id]
          ForemanTasks.trigger(DeployNewHost, job)
        end
        
      end
    end
  end
end