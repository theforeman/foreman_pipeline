class RemoveCvPromoteFromJob < ActiveRecord::Migration
  def up
    remove_column :foreman_pipeline_jobs, :promote
  end

  def down
    add_column :foreman_pipeline_jobs, :promote, :boolean, :default => false
  end
end
