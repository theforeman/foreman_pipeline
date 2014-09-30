$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "integration/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "integration"
  s.version     = Integration::VERSION
  s.authors     = ["N/A"]
  s.email       = ["oprazak@redhat.com"]
  s.homepage    = "http://katello.org"
  s.summary     = ""
  s.description = "Plugin"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
