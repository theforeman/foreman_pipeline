class CreateJenkinsProjectParamsTable < ActiveRecord::Migration
  def up
    create_table "integration_jenkins_project_params" do |t|
      t.string "type",                    :null => false
      t.string "name",                    :null => false
      t.text "description"
      t.string "value",                   :null => false
      t.integer "organization_id",        :null => false
      t.integer "job_jenkins_project_id", :null => false
    end 
  end

  def down
    drop_table :integration_jenkins_project_params
  end
end
