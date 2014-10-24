module Integration
  module Authorization::Job
    extend ActiveSupport::Concern

    include Authorizable
    include Katello::Authorization

    def readable?
      authorized?(:view_jobs)
    end

    def editable?
      authorized?(:edit_jobs)
    end

    def deletable?
      authorized?(:delete_jobs)
    end

    module ClassMethods
      def readable
        authorized(:view_jobs)
      end
    end
  end
end