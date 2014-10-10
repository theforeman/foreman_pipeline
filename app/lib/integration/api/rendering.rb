module Integration
  module Api
    module Rendering

      def respond_with_template(action, resource_name, options = {}, &block)
        yield if block_given?
        status = options[:status] || 200

        render :template => "integration/api/#{resource_name}/#{action}",
               :status => status,
               :locals => { :object_name => options[:object_name],
                            :root_name => options[:root_name] },
               :layout => "katello/api/v2/layouts/#{options[:layout]}" 
      end
      
    end
  end
end