class AddCertPathToJenkinsInstances < ActiveRecord::Migration
  def up
    add_column :integration_jenkins_instances, :cert_path, :string, :null => false, :default => "~/.ssh/id_rsa"
  end

  def down
    remove_column :integration_jenkins_instances, :cert_path
  end
end
