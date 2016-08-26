require 'foreman_pipeline/monkeys'
require 'bastion'
require 'katello'
require 'net/ssh'
require 'net/scp'

module ForemanPipeline
  class Engine < ::Rails::Engine
    isolate_namespace ForemanPipeline

    initializer 'foreman_pipeline.assets_dispatcher', :before => :build_middleware_stack do |app|
      app.middleware.use ::ActionDispatch::Static, "#{ForemanPipeline::Engine.root}/app/assets/javascripts/foreman_pipeline"
    end

    initializer 'foreman_pipeline.mount_engine', :after => :build_middleware_stack do |app|
      app.routes_reloader.paths << "#{ForemanPipeline::Engine.root}/config/mount_engine.rb"
    end

    initializer 'foreman_pipeline.load_app_instance_data' do |app|
      ForemanPipeline::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
      app.config.autoload_paths += Dir["#{config.root}/app/lib"]
      app.config.autoload_paths += Dir["#{config.root}/app/views/foreman"]
    end

    initializer 'foreman_pipeline.register_plugin', :before => :finisher_hook do
      require 'foreman_pipeline/plugin'
      require 'foreman_pipeline/permissions'
      require 'foreman_pipeline/roles'
      require 'foreman_pipeline/skip_tests'
    end

    initializer 'foreman_pipeline.configure_assets', :group => :all do |app|
      SETTINGS[:foreman_pipeline] = {
        :assets => {
          :precompile => [
            'foreman_pipeline/foreman_pipeline.js',
            'foreman_pipeline/foreman_pipeline.css'
          ]
        }
      }
    end

    initializer 'foreman_pipeline.assets.precompile', :after => 'foreman_pipeline.configure_assets' do |app|
      app.config.assets.precompile += SETTINGS[:foreman_pipeline][:assets][:precompile]
    end

    initializer "foreman_pipeline.apipie" do
      Apipie.configuration.checksum_path += ['/foreman_pipeline/api/']
    end

    initializer 'foreman_pipeline.register_actions', :before => 'foreman_tasks.initialize_dynflow' do |app|
      ForemanTasks.dynflow.require!

      action_paths = %W(#{ForemanPipeline::Engine.root}/app/lib/actions)

      ForemanTasks.dynflow.config.eager_load_paths.concat(action_paths)
    end

    config.to_prepare do

      ::Bastion.register_plugin({
        :name => 'foreman_pipeline',
        :javascript => 'foreman_pipeline/foreman_pipeline',
        :stylesheet => 'foreman_pipeline/foreman_pipeline',
        :pages => %w(
            jobs
            jenkins_instances
          )
        })

      # extensions
      ::Katello::Repository.send :include, ForemanPipeline::Concerns::RepositoryExtension
      ::Katello::ContentViewRepository.send :include, ForemanPipeline::Concerns::ContentViewRepositoryExtension
      ::Katello::ContentView.send :include, ForemanPipeline::Concerns::ContentViewExtension
      ::Katello::KTEnvironment.send :include, ForemanPipeline::Concerns::KtEnvironmentExtension
      ::Hostgroup.send :include, ForemanPipeline::Concerns::HostgroupExtension
      ::ComputeResource.send :include, ForemanPipeline::Concerns::ComputeResourceExtension
    end


    rake_tasks do
      load "#{ForemanPipeline::Engine.root}/lib/foreman_pipeline/tasks/test.rake"
    end

  end
end
