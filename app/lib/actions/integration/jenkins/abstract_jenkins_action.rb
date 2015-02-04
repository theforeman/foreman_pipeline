module Actions
  module Integration
    module Jenkins
      class AbstractJenkinsAction < Actions::EntryAction
        
        def job
          j = ::Integration::Job.find input.fetch(:job_id)
          j.init_run
          j
        end
      end
    end
  end
end