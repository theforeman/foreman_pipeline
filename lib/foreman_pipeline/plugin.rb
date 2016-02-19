Foreman::Plugin.register :foreman_pipeline do
  requires_foreman '>= 1.9'

  sub_menu :top_menu, :foreman_pipeline_menu, :caption => N_('Pipeline') do
    menu :top_menu,
         :jobs,
         :caption => N_("Jobs"),
         :url => '/jobs',
         :url_hash => {:controller => 'foreman_pipeline/api/jobs', :action => 'index'},
         :engine => ForemanPipeline::Engine
    menu :top_menu,
         :jenkins_instances,
         :caption => N_("Jenkins Instances"),
         :url => '/jenkins_instances',
         :url_hash => {:controller => 'foreman_pipeline/api/jenkins_instances', :action => 'index'},
         :engine => ForemanPipeline::Engine

    #skipping Bastion routes as they have no permissions
    tests_to_skip({"AccessPermissionsTest" => ["route_bastion/bastion/index should have a permission that grants access",
                                               "route_bastion/bastion/index_ie should have a permission that grants access"
                                               "route katello/api/v2/host_packages/auto_complete_search should have a permission that grants access"],
    #skipping seeds tests because katello adds its settings and we get 'unexpected invocation'  for mock object
                    "SeedsTest" => ["with defaults",
                                    "with environment defaults",
                                    "all access permissions are created by permissions seed",
                                    "doesn't add a template back that was deleted",
                                    "doesn't add a template back that was renamed",
                                    "don't seed location when a location already exists",
                                    "don't seed organization when an org already exists",
                                    "is idempotent",
                                    "no audits are recorded",
                                    "populates bookmarks",
                                    "populates config templates",
                                    "populates features",
                                    "populates hidden admin users",
                                    "populates installation media",
                                    "populates partition tables",
                                    "seed location when environment",
                                    "seed location when environment SEED_LOCATION specified",
                                    "seed organization when environment SEED_ORGANIZATION specified",
                                    "viewer role contains all view permissions"],
                    "LocationTest" => ["selected_or_inherited_ids for inherited location",
                                       "used_and_selected_or_inherited_ids for inherited location"],
                    "OrganizationTest" => ["name can be the same if parent is different",
                                           ".my_organizations returns user's associated orgs and children"],
    #parent_id for organization is disabled by default
                    "TaxonomixTest" => [".used_organization_ids can work with array of organizations"],
    #bunch of broken tests, various causes
                    "UserTest" => ["when a user logs in, last login time should be updated",
                                   "return organization and child ids for non-admin user",
                                   "#ensure_last_admin_is_not_deleted with non-admins",
                                   "can search users by role id"],
                    "UsergroupTest" => ["delete user if not in LDAP directory",
                                        "add user if in LDAP directory",
                                        "hosts should be retrieved from recursive/complex usergroup definitions",
                                        "cannot be destroyed when in use by a host",
                                        "add_users is case insensitive and does not add nonexistent users",
                                        "remove users removes user list and is case insensitive"],
    })
  end
end
