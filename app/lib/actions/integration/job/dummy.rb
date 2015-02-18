module Actions
  module Integration
    module Job
      class Dummy < Actions::EntryAction
        middleware.use ::Actions::Middleware::RemoteAction
        
        def run
          output[:dummy] = "Dummy action triggered for Job: #{input[:job_name]}"
        end

      end
    end
  end
end