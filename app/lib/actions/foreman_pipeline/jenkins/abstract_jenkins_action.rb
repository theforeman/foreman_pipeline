module Actions
  module ForemanPipeline
    module Jenkins
      class AbstractJenkinsAction < Actions::EntryAction
        
        def job
          j = ::ForemanPipeline::Job.find input.fetch(:job_id)
          fail "no jenkins instance specified for the job with id #{j.id}" if j.jenkins_instance.nil?
          j.init_run
          j
        end

        def jenkins_project
          ::ForemanPipeline::JenkinsProject.find input[:project_id]
        end
        
      end
    end
  end
end