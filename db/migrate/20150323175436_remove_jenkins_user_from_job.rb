class RemoveJenkinsUserFromJob < ActiveRecord::Migration
  def up
    remove_column :foreman_pipeline_jobs, :jenkins_user_id
  end

  def down
    add_column :foreman_pipeline_jobs, :jenkins_user_id, :integer
  end
end
