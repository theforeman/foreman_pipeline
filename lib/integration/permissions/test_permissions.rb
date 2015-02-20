require 'integration/plugin'

Foreman::Plugin.find(:integration).security_block :tests do
  permission :view_tests,
              {
                'integration/tests' => [:all, :index, :show],
                'integration/api/tests' => [:index, :show],
              },
              :resource_type => 'Integration::Test'
  permission :create_tests,
              {
                'integration/api/tests' => [:create],
              },
              :resource_type => 'Integration::Test'
  permission :edit_tests,
              {
                'integration/api/tests' => [:update],
              },
              :resource_type => 'Integration::Test'
  permission :destroy_tests,
              {
                'integration/api/tests' => [:destroy],
              },
              :resource_type => 'Integration::Test'
end