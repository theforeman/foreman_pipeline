require 'foreman_pipeline/plugin'

viewer_permissions = [:view_jobs, :view_jenkins_instances, :view_jenkins_users,
                     :view_jenkins_projects, :view_jenkins_requests]
manager_permissions = [:view_jobs, :edit_jobs, :destroy_jobs, :create_jobs, 
                       :view_jenkins_instances, :edit_jenkins_instances, :destroy_jenkins_instances, :create_jenkins_instances,
                        :view_jenkins_users, :edit_jenkins_users, :destroy_jenkins_users, :create_jenkins_users,
                        :view_jenkins_projects,
                        :edit_jenkins_project_params, 
                        :view_jenkins_requests]

Foreman::Plugin.find(:foreman_pipeline).send :role, "Pipeline viewer", viewer_permissions
Foreman::Plugin.find(:foreman_pipeline).send :role, "Pipeline manager", manager_permissions