class CreateJobPath < ActiveRecord::Migration
  def up
    create_table :foreman_pipeline_job_paths do |t|
      t.integer "job_id"
      t.integer "path_id"
      t.integer "organization_id"
    end
  end

  def down
    drop_table :foreman_pipeline_job_paths
  end
end
