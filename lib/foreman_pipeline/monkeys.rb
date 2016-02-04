module ActiveRecord
  class Base
    # adding to_hash to enable for using in dynflog actions' output
    def to_hash
      attributes
    end
  end
end
