class RenameTables < ActiveRecord::Migration
  def up
    rename_table :integration_jobs, :foreman_pipeline_jobs
    rename_table :integration_jenkins_users, :foreman_pipeline_jenkins_users
    rename_table :integration_jenkins_instances, :foreman_pipeline_jenkins_instances
    rename_table :integration_jenkins_project_params, :foreman_pipeline_jenkins_project_params
    rename_table :integration_jenkins_projects, :foreman_pipeline_jenkins_projects
    rename_table :integration_job_jenkins_projects, :foreman_pipeline_job_jenkins_projects
  end

  def down
    rename_table :foreman_pipeline_jobs, :integration_jobs
    rename_table :foreman_pipeline_jenkins_users, :integration_jenkins_users
    rename_table :foreman_pipeline_jenkins_instances, :integration_jenkins_instances
    rename_table :foreman_pipeline_jenkins_project_params, :integration_jenkins_project_params
    rename_table :foreman_pipeline_jenkins_projects, :integration_jenkins_projects
    rename_table :foreman_pipeline_job_jenkins_projects, :integration_job_jenkins_projects
  end
end
