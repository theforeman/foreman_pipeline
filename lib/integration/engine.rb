module Integration
  class Engine < ::Rails::Engine
    isolate_namespace Integration

    initializer 'integration.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{Integration::Engine.root}/config/mount_engine.rb"
    end

    initializer 'integration.register_plugin', :after => :finisher_hook do
      require 'integration/plugin'
      # require 'integration/permissions'
    end 

    initializer 'integration.load_migrations' do |app|
      app.config.paths['db/migrate'] += Integration::Engine.paths['db/migrate'].existent
      
    end
  end
end
