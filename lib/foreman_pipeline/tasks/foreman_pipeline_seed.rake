namespace :foreman_pipeline  do

  desc "seeding the database"
  task :seed => :environment do
    defaults = {:default => true, :locked => false}
    templates = [{:name => "foreman_pipeline_jenkins_pubkey", :source => "snippets/_jenkins_instance_pubkey.erb", :snippet => true}]

    templates.each do |template|
      template[:template] = File.read(File.join(ForemanPipeline::Engine.root, "app/views/foreman/unattended", template.delete(:source)))

      ::ConfigTemplate.find_or_create_by_name(template) do |tmplt|
        tmplt.update_attributes(defaults.merge(template))
      end
    end
  end
end