class CreateJenkinsUsers < ActiveRecord::Migration
  def up
    create_table "integration_jenkins_users" do |t|
      t.string "name",                  :null => false
      t.string "token",                 :null => false
      t.integer "organization_id",      :null => false
      t.integer "jenkins_instance_id",  :null => false
      t.integer "user_id",              :null => false
    end
  end

  def down
    drop_table "integration_jenkins_users"
  end
end
