require File.expand_path("../engine", File.dirname(__FILE__))

namespace :test do
  
  namespace :integration do
    
    task :test => ['db:test:prepare'] do
      test_task = Rake::TestTask.new('integration_test_task') do |t|
        t.libs << ["test", "#{Integration::Engine.root}/test"]
        t.test_files = ["#{Integration::Engine.root}/test/**/*_test.rb"]
        t.verbose = true
      end
      Rake::Task[test_task.name].invoke
    end

    task :spec => ['db:test:prepare'] do
      test_task = Rake::TestTask.new('integration_spec_task') do |t|
        t.libs << ["spec", "#{Integration::Engine.root}/spec", "test", "#{Integration::Engine.root}/test"]
        t.test_files = ["#{Integration::Engine.root}/spec/**/*_spec.rb"]
        t.verbose = true
      end
      Rake::Task[test_task.name].invoke
    end
  end


  desc "run all plugin's tests"
  task :integration do
    Rake::Task['test:integration:test'].invoke
    Rake::Task['test:integration:spec'].invoke
  end

end
  
