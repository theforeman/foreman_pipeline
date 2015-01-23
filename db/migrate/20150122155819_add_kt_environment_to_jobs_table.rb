class AddKtEnvironmentToJobsTable < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :environment_id, :integer
  end

  def down
    remove_column :integration_jobs, :environment_id
  end
end
