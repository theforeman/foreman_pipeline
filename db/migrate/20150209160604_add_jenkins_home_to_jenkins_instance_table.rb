class AddJenkinsHomeToJenkinsInstanceTable < ActiveRecord::Migration
  def up
    add_column :integration_jenkins_instances, :jenkins_home, :string, :null => false, :default => "", :limit => 255
  end

  def down
    remove_column :integration_jenkins_instances, :jenkins_home
  end
end
