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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "foreman_deployments", "~> 0.0.1"
  s.add_dependency "jenkins_api_client", "> 1.4.0"
  s.add_dependency "katello", "> 2.4.0.rc2"
  s.add_dependency "bastion", "~> 2.0"
  s.add_dependency "net-ssh"
  s.add_dependency "net-scp", "~> 1.2"
  s.add_dependency "less-rails", "~> 2.5.0" #to install in test env for bastion
end
