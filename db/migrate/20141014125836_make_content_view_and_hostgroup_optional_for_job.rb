class MakeContentViewAndHostgroupOptionalForJob < ActiveRecord::Migration
  def up
    change_column_null :integration_jobs, :content_view_id, true
    change_column_null :integration_jobs, :hostgroup_id, true
  end

  def down
    change_column_null :integration_jobs, :content_view_id, false
    change_column_null :integration_jobs, :hostgroup_id, false
  end
end
