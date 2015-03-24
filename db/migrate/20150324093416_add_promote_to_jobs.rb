class AddPromoteToJobs < ActiveRecord::Migration
  def up
    add_column :foreman_pipeline_jobs, :promote, :boolean, :default => false
  end

  def down
    remove_column :foreman_pipeline_jobs, :promote
  end
end
