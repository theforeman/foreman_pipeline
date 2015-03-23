class RemoveOwnerFromJenkinsUser < ActiveRecord::Migration
  def up
    remove_column :foreman_pipeline_jenkins_user, :owner_id
  end

  def down
    add_column :foreman_pipeline_jenkins_user, :owner_id, :integer
  end
end
