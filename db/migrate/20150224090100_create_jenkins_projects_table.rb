class CreateJenkinsProjectsTable < ActiveRecord::Migration
  def up
    create_table "integration_jenkins_projects" do |t|
      t.string "name",                  :null => false
    end
    
    create_table "integration_job_jenkins_projects" do |t|
      t.integer "job_id"              
      t.integer "jenkins_project_id" 
      t.datetime "created_at",          :null => false
      t.datetime "updated_at",          :null => false
    end    
  end

  def down
    drop_table :integration_job_jenkins_projects
    drop_table :integration_jenkins_projects
  end
end
