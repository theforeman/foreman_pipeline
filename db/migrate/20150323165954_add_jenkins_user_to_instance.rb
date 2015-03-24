class AddJenkinsUserToInstance < ActiveRecord::Migration
  def up
    add_column :foreman_pipeline_jenkins_instances, :jenkins_user_id, :integer
  end

  def down
    remove_column :foreman_pipeline_jenkins_instances, :jenkins_user_id
  end
end
