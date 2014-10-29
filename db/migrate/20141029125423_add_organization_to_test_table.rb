class AddOrganizationToTestTable < ActiveRecord::Migration
  def up
    add_column :integration_tests, :organization_id, :integer, :null => false
  end

  def down
    remove_column :integration_tests, :organization_id
  end
end
