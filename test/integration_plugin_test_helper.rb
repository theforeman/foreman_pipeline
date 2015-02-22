require 'test_helper'

# requiring Katello's helper does not work, it requires more files that cannot be reached
# require "#{Integration::Engine::Railties.engines
# .select {|engine| engine.railtie_name == "katello"}
# .first.config.root}/test/katello_test_helper"

# Add plugin to FactoryGirl's paths
# FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
# FactoryGirl.reload
