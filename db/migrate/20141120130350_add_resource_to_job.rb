class AddResourceToJob < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :compute_resource_id, :integer
  end

  def down
    remove_column :integration_jobs, :compute_resource_id
  end
end
