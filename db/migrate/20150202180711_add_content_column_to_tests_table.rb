class AddContentColumnToTestsTable < ActiveRecord::Migration
  def up
    add_column :integration_tests, :content, :text
  end

  def down
    remove_column :integration_tests, :content
  end
end
