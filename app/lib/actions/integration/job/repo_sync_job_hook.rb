module Actions
  module Integration
    module Job
      class RepoSyncJobHook < CvHook
        
        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo)
          valid_jobs = repo.jobs.select { |job| job.is_valid? }

          jobs_to_run = valid_jobs.select { |job| job.target_cv_version_avail? }
          allowed_jobs = jobs_to_run.select { |job| job.sync_trigger && !job.version_already_promoted? }
          grouped_jobs = allowed_jobs.group_by(&:target_cv_version).values

          if grouped_jobs.max_by(&:length).length > 1
            grouped_jobs = grouped_jobs.max_by(&:length)

            plan_self(:trigger => trigger.output,
                      :job_ids => grouped_jobs.map(&:id),
                      :job_names => grouped_jobs.map(&:name))
          else
            grouped_jobs.flatten!
            plan_self(:trigger => trigger.output,
                      :job_names => [],
                      :job_ids => grouped_jobs.map(&:id))
          end
        end

        # def run
        # end    

      end
    end
  end
end