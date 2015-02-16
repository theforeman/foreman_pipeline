class AddBuildStepToTestsTable < ActiveRecord::Migration
  def up
    add_column :integration_tests, :build_step, :text
  end

  def down
    remove_column :integration_tests, :build_step
  end
end
