class AddPubkeyToJenkinsInstanceTable < ActiveRecord::Migration
  def up
    add_column :integration_jenkins_instances, :pubkey, :text
  end

  def down
    remove_column :integration_jenkins_instances, :pubkey
  end
end
