class RenameJobPath < ActiveRecord::Migration
  def up
    rename_table :foreman_pipeline_job_paths, :foreman_pipeline_job_to_environments
    rename_column :foreman_pipeline_job_to_environments, :path_id, :to_environment_id 
  end

  def down
    rename_table :foreman_pipeline_job_to_environments, :foreman_pipeline_job_paths
    rename_column :foreman_pipeline_job_paths, :to_environment_id , :path_id
  end
end
