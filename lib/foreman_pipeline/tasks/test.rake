require File.expand_path("../engine", File.dirname(__FILE__))

namespace :test do
  desc "Run plugin test suite"
  task :foreman_pipeline => ['db:test:prepare'] do
    test_task = Rake::TestTask.new('foreman_pipeline_test_task') do |t|
      t.libs << ["test", "#{ForemanPipeline::Engine.root}/test"]
      t.test_files = ["#{ForemanPipeline::Engine.root}/test/**/*_test.rb"]
      t.warning = false
      t.verbose = true
    end
    Rake::Task[test_task.name].invoke
  end
end

namespace :foreman_pipeline do
  task :rubocop do
    begin
      require 'rubocop/rake_task'
      RuboCop::RakeTask.new(:rubocop_foreman_pipeline) do |task|
        task.patterns = ["#{ForemanPipeline::Engine.root}/app/**/*.rb",
        "#{ForemanPipeline::Engine.root}/lib/**/*.rb",
        "#{ForemanPipeline::Engine.root}/test/**/*.rb"]
      end
    rescue
      puts 'Rubocop not loaded.'
    end
    Rake::Task['rubocop_foreman_pipeline'].invoke
  end
end

Rake::Task[:test].enhance do
  Rake::Task['test:foreman_pipeline'].invoke
end

load 'tasks/jenkins.rake'
if Rake::Task.task_defined?(:'jenkins:unit')
  Rake::Task["jenkins:unit"].enhance do
    Rake::Task['test:foreman_pipeline'].invoke
  end
end
