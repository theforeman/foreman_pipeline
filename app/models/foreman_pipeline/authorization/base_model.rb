module ForemanPipeline
  module Authorization::BaseModel
    extend ActiveSupport::Concern

    include Authorizable
    include Katello::Authorization

    def readable?
      authorized?(self.normalize_name("read"))
    end

    def editable?
      authorized?(self.normalize_name("edit"))
    end

    def deletable?
      authorized?(self.normalize_name("delete"))
    end

    module ClassMethods
      def readable
        authorized(normalize_name("view"))
      end

      def normalize_name(action_string)
        (action_string + self.class.name.demodulize.pluralize).underscore.to_sym
      end
    end
  end
end