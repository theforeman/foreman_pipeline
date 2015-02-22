require 'test_helper'

def katello_root
  "#{Integration::Engine::Railties.engines
    .select {|engine| engine.railtie_name == "katello"}
    .first.config.root}"  
end

# requiring Katello's helper does not work, it requires more files that cannot be reached
# require "#{katello_root}/test/katello_test_helper"

# Add plugin to FactoryGirl's paths
# FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
# FactoryGirl.reload
