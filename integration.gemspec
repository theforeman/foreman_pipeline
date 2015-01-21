$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "integration"
  s.version     = Integration::VERSION
  s.authors     = ["N/A"]
  s.email       = ["oprazak@redhat.com"]
  s.homepage    = "https://github.com/xprazak2/abcde/wiki/Implemented-Features"
  s.summary     = ""
  s.description = "Plugin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "rabl"
  s.add_development_dependency "sass", "3.2.13"  
  
  # s.add_dependency "jenkins_api_client"
  
  s.add_development_dependency "sqlite3"
end
