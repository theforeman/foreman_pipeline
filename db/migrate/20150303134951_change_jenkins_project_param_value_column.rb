class ChangeJenkinsProjectParamValueColumn < ActiveRecord::Migration
  def up
    change_column :integration_jenkins_project_params, :value, :text
  end

  def down
    change_column :integration_jenkins_project_params, :value, :string
  end
end
