class DropOrphanedTable < ActiveRecord::Migration
  def up
    drop_table :integration_jobs_tests
  end

  def down
  end
end
