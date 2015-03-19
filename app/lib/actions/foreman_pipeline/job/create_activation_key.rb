module Actions
  module ForemanPipeline
    module Job
      class CreateActivationKey < Actions::EntryAction
        middleware.use ::Actions::Middleware::KeepCurrentUser

        def run
          output[:new_key] = ::Katello::ActivationKey.create(
                        name:             "key-for-#{input[:name]}",
                        organization_id:   input[:organization_id],
                        environment_id:    input[:environment_id],
                        content_view_id:   input[:content_view_id],
                        user_id:           ::User.current.id,
                        cp_id:             input[:cp_id] 
                      )
        end
      end
    end
  end
end