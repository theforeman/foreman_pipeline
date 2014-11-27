class RemoveResourceFromJob < ActiveRecord::Migration
  def up
    remove_column :integration_jobs, :compute_resource_id
  end

  def down
    add_column :integration_jobs, :compute_resource_id, :integer
  end
end
