loc = Location.find_or_create_by(:name => "foreman_pipeline")
loc.organizations = Organization.all
loc.environments = Environment.all
loc.domains = Domain.all
loc.media = Medium.all
loc.subnets = Subnet.all
loc.compute_resources = ComputeResource.all
loc.smart_proxies = SmartProxy.all
loc.save!
