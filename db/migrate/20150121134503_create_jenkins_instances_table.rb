class CreateJenkinsInstancesTable < ActiveRecord::Migration
  def up
    create_table "integration_jenkins_instances" do |t|
      t.string "name",              :null => false
      t.string "url",               :null => false
      t.integer "organization_id",   :null => false
    end
  end

  def down
    drop_table "integration_jenkins_instances"
  end
end
