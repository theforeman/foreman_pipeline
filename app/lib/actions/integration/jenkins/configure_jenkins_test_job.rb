require 'erb'
module Actions
  module Integration
    module Jenkins
      class ConfigureJenkinsTestJob < ConfigureJenkinsJob
        
        def params_hash
          {:shell_command => shell, :name => input.fetch(:name)}
        end

        def shell
          filename = input.fetch(:test_name)
          temp = ERB.new(input.fetch(:shell_command)).result(binding)
        end
      end
    end
  end
end