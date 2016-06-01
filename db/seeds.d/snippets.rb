defaults = { :default => true, :locked => false }

ProvisioningTemplate.without_auditing do
  [
    { :name => "pipeline_jenkins_pubkey", :source => "snippets/_jenkins_instance_pubkey.erb", :snippet => true }
  ].each do |template|
      next if ProvisioningTemplate.find_by_name(template[:name]).present?
      template[:template] = File.read(File.join(ForemanPipeline::Engine.root, "app/views/foreman/unattended", template.delete(:source)))
      ProvisioningTemplate.create(defaults.merge(template))
    end
end
