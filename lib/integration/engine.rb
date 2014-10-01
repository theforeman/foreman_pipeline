module Integration
  class Engine < ::Rails::Engine
    isolate_namespace Integration

    initializer 'integration.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{Integration::Engine.root}/config/mount_engine.rb"
    end

    initializer 'integration.register_plugin', :after => :finisher_hook do
      require 'integration/plugin'
    end 
  end
end
