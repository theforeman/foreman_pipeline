module ForemanPipeline
  module Authorization::JenkinsUser
    extend ActiveSupport::Concern

    include Authorization::BaseModel
  end
end