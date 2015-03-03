object @resource

attributes :id, :name

child :jenkins_project_params => :jenkins_project_params do |param|
  extends "integration/api/jenkins_project_params/show"
end