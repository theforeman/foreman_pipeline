class AddUniquenessToTestName < ActiveRecord::Migration
  def up
    add_index :integration_tests, :name, :unique => true
  end

  def down
    remove_index :integration_tests, :name
  end
end
