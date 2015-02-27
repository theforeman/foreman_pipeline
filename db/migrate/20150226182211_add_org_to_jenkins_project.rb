class AddOrgToJenkinsProject < ActiveRecord::Migration
  def up
    add_column :integration_jenkins_projects, :organization_id, :integer, :null => false
  end

  def down
    remove_column :integration_jenkins_projects, :organization_id
  end
end
