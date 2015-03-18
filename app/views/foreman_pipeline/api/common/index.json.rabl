collection @collection

extends "katello/api/v2/common/metadata"

child @collection[:results] => :results do
  extends("foreman_pipeline/api/%s/show" % controller_name)
end