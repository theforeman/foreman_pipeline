module ForemanPipeline
  class JobFilter

    def allow_run_for?(job)
     allowed?(job) && job.target_cv_version_avail?
    end

    def allowed?(job)
      job.is_valid? && job.not_yet_promoted?
    end

    def allowed_jobs_for_repo(repo)
      jobs = ForemanPipeline::Job.where(:content_view_id => repo.content_view_ids)
      jobs.select { |job| allow_run_for?(job) && job.sync_trigger }
    end

    def allowed_jobs_for_cvv(version)
      jobs = ForemanPipeline::Job.where(:content_view_id => version.content_view_id)
      jobs.select do |job|
        allowed?(job) &&
        job.levelup_trigger &&
        version == job.target_cv_version
      end
    end

    def allowed_jobs_for_cv(content_view)
      content_view.jobs.select do |job|
        allowed?(job) &&
        job.environment.library? &&
        job.levelup_trigger
      end
    end
  end
end
