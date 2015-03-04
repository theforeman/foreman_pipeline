class ChangeJenkinsProjectParamsTable < ActiveRecord::Migration
  def up
    rename_column :integration_jenkins_project_params, :job_jenkins_project_id, :jenkins_project_id
  end

  def down
    rename_column :integration_jenkins_project_params,  :jenkins_project_id, :job_jenkins_project_id
  end
end
