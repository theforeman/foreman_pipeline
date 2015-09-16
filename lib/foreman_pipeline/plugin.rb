Foreman::Plugin.register :foreman_pipeline do
  
  sub_menu :top_menu, :foreman_pipeline_menu, :caption => N_('Pipeline') do
    menu :top_menu,
         :jobs,       
         :caption => N_("Jobs"),
         :url => '/jobs',
         :url_hash => {:controller => 'foreman_pipeline/api/jobs', :action => 'index'},
         :engine => ForemanPipeline::Engine
    menu :top_menu,
         :jenkins_instances,
         :caption => N_("Jenkins Instances"),
         :url => '/jenkins_instances',
         :url_hash => {:controller => 'foreman_pipeline/api/jenkins_instances', :action => 'index'},
         :engine => ForemanPipeline::Engine
  end

  require 'foreman_pipeline/permissions'

  role "Pipeline viewer", [:view_jobs, :view_jenkins_instances, :view_jenkins_users,
                     :view_jenkins_projects, :view_jenkins_project_params, :view_jenkins_requests]

  role "Pipeline manager", [:view_jobs, :edit_jobs, :destroy_jobs, :create_jobs, 
                        :view_jenkins_instances, :edit_jenkins_instances, :destroy_jenkins_instances, :create_jenkins_instances,
                        :view_jenkins_users, :edit_jenkins_users, :destroy_jenkins_users, :create_jenkins_users,
                        :view_jenkins_projects,
                        :edit_jenkins_project_params, 
                        :view_jenkins_requests]
end
