module Actions
  module Integration
    module Job
      class CvPromoteJobHook < Actions::EntryAction

        def self.subscribe
          Katello::ContentView::Promote
        end

        def plan(version, environment, is_force)          
          plan_self(:trigger => trigger.output)         

          valid_jobs = version.content_view.jobs.select { |job| job.is_valid? }
          jobs_to_run = valid_jobs.select { |job| version.eql? job.target_cv_version }        
          
          jobs_to_run.each do |job|
            
            if job.levelup_trigger              
              plan_action(Dummy, :job_name => job.name) 
            end

          
          end
        end

        def run          
        end
        
      end
    end
  end
end