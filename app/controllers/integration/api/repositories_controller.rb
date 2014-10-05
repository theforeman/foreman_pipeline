$:.unshift "#{Katello::Engine.root}/app/controllers/katello/api/v2"
require 'repositories_controller'

module Integration
  class Api::RepositoriesController < Katello::Api::V2::RepositoriesController
  end
end