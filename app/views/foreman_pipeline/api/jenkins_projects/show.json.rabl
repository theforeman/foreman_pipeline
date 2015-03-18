object @resource

attributes :id, :name

child :jenkins_project_params => :jenkins_project_params do |param|
  extends "foreman_pipeline/api/jenkins_project_params/show"
end