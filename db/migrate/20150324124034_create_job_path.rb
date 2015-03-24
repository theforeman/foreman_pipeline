class CreateJobPath < ActiveRecord::Migration
  def up
    create_table :foreman_pipeline_job_paths do |t|
      t.integer "job_id"
      t.integer "path_id"
      t.integer "organization_id"
    end

    add_column :foreman_pipeline_jobs, :job_path_id, :integer
    add_column :katello_environments, :job_path_id, :integer
  end

  def down
    drop_table :foreman_pipeline_job_paths
    remove_column :foreman_pipeline_jobs, :path_id
    remove_column :katello_environments, :job_path_id
  end
end
