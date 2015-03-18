require File.expand_path("../engine", File.dirname(__FILE__))

namespace :test do
  
  namespace :foreman_pipeline do
    
    task :test => ['db:test:prepare'] do
      test_task = Rake::TestTask.new('foreman_pipeline_test_task') do |t|
        t.libs << ["test", "#{ForemanPipeline::Engine.root}/test"]
        t.test_files = ["#{ForemanPipeline::Engine.root}/test/**/*_test.rb"]
        t.verbose = true
      end
      Rake::Task[test_task.name].invoke
    end

    task :spec => ['db:test:prepare'] do
      test_task = Rake::TestTask.new('foreman_pipeline_spec_task') do |t|
        t.libs << ["spec", "#{ForemanPipeline::Engine.root}/spec", "test", "#{ForemanPipeline::Engine.root}/test"]
        t.test_files = ["#{ForemanPipeline::Engine.root}/spec/**/*_spec.rb"]
        t.verbose = true
      end
      Rake::Task[test_task.name].invoke
    end
  end


  desc "run all plugin's tests"
  task :foreman_pipeline do
    Rake::Task['test:foreman_pipeline:test'].invoke
    Rake::Task['test:foreman_pipeline:spec'].invoke
  end

end
  
