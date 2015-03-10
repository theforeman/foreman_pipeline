module Actions
  module Integration
    module Jenkins
      class AbstractJenkinsAction < Actions::EntryAction
        
        def job
          j = ::Integration::Job.find input.fetch(:job_id)
          fail "no jenkins instance specified for the job with id #{j.id}" if j.jenkins_instance.nil?
          j.init_run
          j
        end

        def jenkins_project
          ::Integration::JenkinsProject.find input[:project_id]
        end
        
      end
    end
  end
end