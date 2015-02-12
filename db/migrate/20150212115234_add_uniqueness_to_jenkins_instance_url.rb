class AddUniquenessToJenkinsInstanceUrl < ActiveRecord::Migration
  def up
    add_index :integration_jenkins_instances, :url, :unique => true
  end

  def down
    remove_index :integration_jenkins_instances, :url
  end
end
