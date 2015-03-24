class RemoveJenkinsInstanceFromUser < ActiveRecord::Migration
  def up
    remove_column :foreman_pipeline_jenkins_users, :jenkins_instance_id
  end

  def down
    add_column :foreman_pipeline_jenkins_users, :jenkins_instance_id, :integer
  end
end
