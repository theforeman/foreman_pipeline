class ChangeJenkinsUserOwner < ActiveRecord::Migration
  def up
    rename_column :integration_jenkins_users, :user_id, :owner_id
  end

  def down
    rename_column :integration_jenkins_users, :owner_id, :user_id 
  end
end
