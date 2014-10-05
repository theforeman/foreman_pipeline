class CreateJobTable < ActiveRecord::Migration
  def up
    create_table "integration_jobs" do |t|
      t.string "name",              :null => false
      t.integer "content_view_id",  :null => false
      t.integer "hostgroup_id",     :null => false
    end
  end

  def down
    drop table "integration_jobs"
  end
end
