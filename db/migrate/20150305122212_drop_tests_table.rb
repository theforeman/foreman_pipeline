class DropTestsTable < ActiveRecord::Migration
  def change
    drop_table :integration_tests
  end
end
