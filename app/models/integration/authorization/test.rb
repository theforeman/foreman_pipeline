module Integration
  module Authorization::Test
    extend ActiveSupport::Concern

    include Authorizable
    include Katello::Authorization

    def readable?
      authorized?(:view_tests)
    end

    def editable?
      authorized?(:edit_tests)
    end

    def deletable?
      authorized?(:delete_tests)
    end

    module ClassMethods
      def readable
        authorized(:view_tests)
      end
    end
  end
end