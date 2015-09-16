$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreman_pipeline/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreman_pipeline"
  s.version     = ForemanPipeline::VERSION
  s.authors     = ["Ondřej Pražák"]
  s.email       = ["oprazak@redhat.com"]
  s.homepage    = "https://github.com/xprazak2/foreman-pipeline"
  s.summary     = ""
  s.description = "Makes Foreman talk to Jenkins CI server."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "katello"
  s.add_dependency "foreman_deployments" 
  s.add_dependency "bastion", "< 3.0.0"
  s.add_dependency "net-scp"
  s.add_dependency "jenkins_api_client", "< 2.0.0"
end
