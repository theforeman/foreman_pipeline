class DropJobJenkinsProject < ActiveRecord::Migration
  def up
    jjps = execute("SELECT * FROM foreman_pipeline_job_jenkins_projects;")
    add_column :foreman_pipeline_jenkins_projects, :job_id, :integer
    jjps.each do |jjp|
      project = ForemanPipeline::JenkinsProject.find(jjp['jenkins_project_id'])
      project.job_id = jjp['job_id']
      project.save!
    end
    remove_column :foreman_pipeline_jenkins_projects, :job_jenkins_project_id
    drop_table :foreman_pipeline_job_jenkins_projects
  end

  def down
    create_table :foreman_pipeline_job_jenkins_projects do |t|
      t.integer :job_id
      t.integer :jenkins_project_id
      t.datetime :created_at,          :null => false
      t.datetime :updated_at,          :null => false
    end

    add_column :foreman_pipeline_jenkins_projects, :job_jenkins_project_id, :integer
    projects = execute("SELECT * FROM foreman_pipeline_jenkins_projects;")
    projects.each do |project|
      ForemanPipeline::JobJenkinsProject.create(:job_id => project['job_id'], :jenkins_project_id => project['id'])
    end

    remove_column :foreman_pipeline_jenkins_projects, :job_id
  end
end
