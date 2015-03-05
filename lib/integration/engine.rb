module Integration
  class Engine < ::Rails::Engine
    isolate_namespace Integration

    initializer 'integration.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{Integration::Engine.root}/config/mount_engine.rb"
    end

    initializer 'integration.load_app_instance_data' do |app|
      app.config.paths['db/migrate'] += Integration::Engine.paths['db/migrate'].existent
      app.config.autoload_paths += Dir["#{config.root}/app/lib"]
      app.config.autoload_paths += Dir["#{config.root}/app/views/foreman"]
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
        :stylesheet => 'integration/integration',
        :pages => %w(
            jobs
            jenkins_instances
          )
        })

      # extensions
      ::Katello::Repository.send :include, Integration::Concerns::RepositoryExtension
      ::Katello::ContentViewRepository.send :include, Integration::Concerns::ContentViewRepositoryExtension
      ::Katello::ContentView.send :include, Integration::Concerns::ContentViewExtension
      ::Katello::KTEnvironment.send :include, Integration::Concerns::KtEnvironmentExtension
      ::Hostgroup.send :include, Integration::Concerns::HostgroupExtension
      ::ComputeResource.send :include, Integration::Concerns::ComputeResourceExtension
    end

    rake_tasks do
      load "#{Integration::Engine.root}/lib/integration/tasks/integration_seed.rake"
      load "#{Integration::Engine.root}/lib/integration/tasks/integration_test.rake"
    end
       
  end
end
