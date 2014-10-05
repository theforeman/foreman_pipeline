object @resource

attributes :id, :name

extends "katello/api/v2/common/org_reference"


child :content_view do
  extends "katello/api/v2/content_views/show"
end

child :hostgroup do
  extends "api/v2/hostgroups/show"
end