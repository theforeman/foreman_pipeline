namespace :foreman_pipeline  do

  desc "seeding the database"
  task :seed => :environment do
    defaults = {:default => true, :locked => false}
    ProvisioningTemplate.without_auditing do
      [
        {:name => "foreman_pipeline_jenkins_pubkey", :source => "snippets/_jenkins_instance_pubkey.erb", :snippet => true}
      ].each do |template|
          template[:template] = File.read(File.join(ForemanPipeline::Engine.root, "app/views/foreman/unattended", template.delete(:source)))

          ProvisioningTemplate.find_or_create_by_name(template) do |tmplt|
            tmplt.update_attributes(defaults.merge(template))
          end
        end
    end

    loc = Location.new(:name => "foreman_pipeline")
    loc.organizations = Organization.all
    loc.environments = Environment.all
    loc.domains = Domain.all
    loc.media = Medium.all
    loc.subnets = Subnet.all
    loc.compute_resources = ComputeResource.all
    loc.smart_proxies = SmartProxy.all
    loc.save!
  end
end