module Integration
  class Engine < ::Rails::Engine
    isolate_namespace Integration

    initializer 'integration.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{Integration::Engine.root}/config/mount_engine.rb"
    end

    initializer 'integration.load_migrations' do |app|
      app.config.paths['db/migrate'] += Integration::Engine.paths['db/migrate'].existent      
    end

    initializer 'integration.register_plugin', :after => :finisher_hook do
      require 'integration/plugin'
      require 'integration/permissions'
    end 

    initializer 'integration.assets', :group => :all do |app|
      SETTINGS[:integration] = {
        :assets => {
          :precompile => [
            'integration/integration.js'
          ]
        }
      }
    end

    initializer 'integration.register_actions', :before => 'foreman_tasks.initialize_dynflow' do |app|
      ForemanTasks.dynflow.require!

      action_paths = %W(#{Integration::Engine.root}/app/lib/actions)
      
      ForemanTasks.dynflow.config.eager_load_paths.concat(action_paths)
    end

    config.to_prepare do
      
      Bastion.register_plugin({
        :name => 'integration',
        :javascript => 'integration/integration',
        :pages => %w(
            jobs
            tests
          )
        })

      # extensions
      ::Katello::Repository.send :include, Integration::Concerns::RepositoryExtension
      ::Katello::ContentViewRepository.send :include, Integration::Concerns::ContentViewRepositoryExtension

    end
       
  end
end
