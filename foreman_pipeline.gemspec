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
  s.summary     = "Makes Foreman talk to Jenkins CI server."
  s.description = "Jenkins is able to deploy artifacts onto newly provisioned host by Foreman"

  s.files = Dir["{app,config,db,lib,script}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "jenkins_api_client", "~> 1.4"
  # s.add_dependency "katello", "~> 2.5"
  # s.add_dependency "bastion", "~> 3.0"
  # s.add_dependency "net-ssh", "~> 3.0"
  # s.add_dependency "net-scp", "~> 1.1"
  #TODO: find a way to install this in a test env on jenkins for bastion
  # s.add_dependency "less-rails", "~> 2.5.0"
end
