class UpdateProjectsTable < ActiveRecord::Migration
  def up
    add_column :foreman_pipeline_jenkins_projects, :job_jenkins_project_id, :integer
  end

  def down
    remove_column :foreman_pipeline_jenkins_projects, :job_jenkins_project_id
  end
end
