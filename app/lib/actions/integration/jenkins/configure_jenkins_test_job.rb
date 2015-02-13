module Actions
  module Integration
    module Jenkins
      class ConfigureJenkinsTestJob < ConfigureJenkinsJob
        
        def params_hash
          {:shell_command => shell, :name => input.fetch(:name)}
        end

        def shell
          "sh #{input.fetch(:test_name)}"
        end

      end
    end
  end
end