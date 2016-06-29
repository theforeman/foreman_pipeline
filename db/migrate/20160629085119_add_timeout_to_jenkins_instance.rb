class AddTimeoutToJenkinsInstance < ActiveRecord::Migration
  def up
    add_column :foreman_pipeline_jenkins_instances, :timeout, :integer, :default => 60
  end

  def down
    remove_column :foreman_pipeline_jenkins_instances, :timeout
  end
end
