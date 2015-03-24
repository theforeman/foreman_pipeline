object @resource

attributes :id, :name, :url, :organization_id, :server_version, :jenkins_home, :cert_path

child :jenkins_user => :jenkins_user do
  extends "foreman_pipeline/api/jenkins_users/show"
end