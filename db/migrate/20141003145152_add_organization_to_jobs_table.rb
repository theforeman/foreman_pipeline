class AddOrganizationToJobsTable < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :organization_id, :integer, :null => false
  end

  def down
    remove_column :integration_jobs, :organization_id
  end
end
