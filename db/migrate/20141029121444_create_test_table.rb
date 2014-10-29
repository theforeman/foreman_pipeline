class CreateTestTable < ActiveRecord::Migration
  def up
    create_table "integration_tests" do |t|
      t.string "name",    :null => false
    end
  end

  def down
    drop_table "integration_tests"
  end
end
