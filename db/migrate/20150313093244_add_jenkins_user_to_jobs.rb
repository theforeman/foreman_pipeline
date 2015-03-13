class AddJenkinsUserToJobs < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :jenkins_user_id, :integer
  end

  def down
    remove_column :integration_jobs, :jenkins_user_id
  end
end
