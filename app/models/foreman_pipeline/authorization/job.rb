module ForemanPipeline
  module Authorization::Job
    extend ActiveSupport::Concern

    include Authorization::BaseModel
  end
end