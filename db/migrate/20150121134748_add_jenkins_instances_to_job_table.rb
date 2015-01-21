class AddJenkinsInstancesToJobTable < ActiveRecord::Migration
  def up
    add_column :integration_jobs, :jenkins_instance_id, :integer
  end

  def down
    remove_column :integration_jobs, :jenkins_instance_id
  end
end
