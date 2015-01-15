module Actions
  module Integration
    module Job
      class Dummy < Actions::EntryAction

        def run
          output[:dummy] = "Dummy action triggered"
        end

      end
    end
  end
end