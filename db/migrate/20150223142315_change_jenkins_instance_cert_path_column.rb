class ChangeJenkinsInstanceCertPathColumn < ActiveRecord::Migration
  def up
    change_column :integration_jenkins_instances, :cert_path, :string, :default => "", :limit => 255
  end

  def down
    change_column :integration_jenkins_instances, :cert_path, :string, :default => "~/.ssh/id_rsa"
  end
end
