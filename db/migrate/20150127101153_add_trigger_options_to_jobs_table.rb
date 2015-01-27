class AddTriggerOptionsToJobsTable < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :manual_trigger, :boolean, :default => false, :null => false
    add_column :integration_jobs, :sync_trigger, :boolean, :default => false, :null => false
    add_column :integration_jobs, :levelup_trigger, :boolean, :default => false, :null => false
  end

  def down
    remove_column :integration_jobs, :manual_trigger
    remove_column :integration_jobs, :sync_trigger
    remove_column :integration_jobs, :levelup_trigger
  end
end
