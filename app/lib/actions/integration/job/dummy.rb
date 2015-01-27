module Actions
  module Integration
    module Job
      class Dummy < Actions::EntryAction

        def run
          output[:dummy] = "Dummy action triggered for Job: #{input[:job_name]}"
        end

      end
    end
  end
end