object @resource

attributes :id, :name, :organization_id, :manual_trigger, :sync_trigger, :levelup_trigger

child :content_view => :content_view do
  extends "katello/api/v2/content_views/show"
end

child :hostgroup => :hostgroup do
  extends "api/v2/hostgroups/show"
end

child :compute_resource => :compute_resource do
  extends "api/v2/compute_resources/show"
end

child :jenkins_instance => :jenkins_instance do
  extends "integration/api/jenkins_instances/show"
end

child :environment => :environment do 
  extends "integration/api/environments/show"
end

child :jenkins_projects => :jenkins_projects do |project|
  extends "integration/api/jenkins_projects/show"
end