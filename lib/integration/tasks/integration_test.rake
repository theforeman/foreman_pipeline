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
  end
  # desc "run all plugin's tests"
  # task :integration do
  #   test_task  = Rake::TestTask.new(:integration_tests) do |t|      
  #     t.libs << ["#{Integration::Engine.root}/test", "test", "test/**"]
  #     t.test_files = ["#{Integration::Engine.root}/test/**/*_test.rb"]
  #     t.verbose = true
  #   end
  # end

end
  
