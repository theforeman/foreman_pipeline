module Actions
  module ForemanPipeline
    module Job
      class RepoSyncJobHook < JobHook

        def self.subscribe
          Katello::Repository::Sync
        end

        def plan(repo)
          allowed_jobs = filter.allowed_jobs_for_repo repo

          plan_self(:trigger => trigger.output,
                    :job_ids => allowed_jobs.map(&:id),
                    :job_names => allowed_jobs.map(&:name))
        end
      end
    end
  end
end