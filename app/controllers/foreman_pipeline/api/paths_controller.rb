module ForemanPipeline
  class Api::PathsController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:all_paths]

    api :GET, "/organizations/:organization_id/paths/all_paths", N_("List all environment paths in organization")
    param :organization_id, :number, :sdesc => N_("Organization identifier"), :required => true
    def all_paths
      env_paths = if params[:permission_type] == "promotable"
                    @organization.promotable_promotion_paths
                  else
                    @organization.readable_promotion_paths
                  end

      paths = env_paths.inject([]) do |result, path|
        result << { :environments => [@organization.library] + path }
      end
      paths = [{ :environments => [@organization.library] }] if paths.empty?

      collection = {
        :results => paths,
        :total => paths.size,
        :subtotal => paths.size
      }
      respond_for_index(:collection => collection, :template => '../jobs/available_paths')
    end 
    
  end
end