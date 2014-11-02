class CreateJobsTestsTable < ActiveRecord::Migration
  def up
    create_table "integration_jobs_tests", :id => false do |t|
      t.integer "job_id"
      t.integer "test_id"
    end
  end

  def down
    drop_table "integration_jobs_tests"
  end
end
