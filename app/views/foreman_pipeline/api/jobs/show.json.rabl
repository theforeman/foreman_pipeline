object @resource

attributes :id, :name, :organization_id, :manual_trigger, :sync_trigger,
           :levelup_trigger, :promote

child :content_view => :content_view do
  extends "foreman_pipeline/api/content_views/show"
end

child :hostgroup => :hostgroup do
  extends "foreman_pipeline/api/hostgroups/show"
end

child :compute_resource => :compute_resource do
   extends "foreman_pipeline/api/compute_resources/show"
end

child :jenkins_instance => :jenkins_instance do
  extends "foreman_pipeline/api/jenkins_instances/show"
end

child :environment => :environment do 
  extends "foreman_pipeline/api/environments/show"
end

child :jenkins_projects => :jenkins_projects do |project|
  extends "foreman_pipeline/api/jenkins_projects/show"
end

child :paths => :paths do |path|
  extends "foreman_pipeline/api/environments/show"
end
