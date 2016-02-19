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
    tests_to_skip({"AccessPermissionsTest" => ["test_route_bastion/bastion/index_should_have_a_permission_that_grants_access",
                                               "test_route_bastion/bastion/index_ie_should_have_a_permission_that_grants_access"],
    #skipping seeds tests because katello adds its settings and we get 'unexpected invocation'  for mock object
                    "SeedsTest" => ["test_all_access_permissions_are_created_by_permissions_seed",
                                    "test_doesn't_add_a_template_back_that_was_deleted",
                                    "test_doesn't_add_a_template_back_that_was_renamed",
                                    "test_don't_seed_location_when_a_location_already_exists",
                                    "test_don't_seed_organization_when_an_org_already_exists",
                                    "test_is_idempotent",
                                    "test_no_audits_are_recorded",
                                    "test_populates_bookmarks",
                                    "test_populates_config_templates",
                                    "test_populates_features",
                                    "test_populates_hidden_admin_users",
                                    "test_populates_installation_media",
                                    "test_populates_partition_tables",
                                    "test_seed_location_when_environment",
                                    "test_seed_location_when_environment_SEED_LOCATION_specified",
                                    "test_seed_organization_when_environment_SEED_ORGANIZATION_specified",
                                    "test_viewer_role_contains_all_view_permissions"],
    #parent_id for organization is disabled by default
                    "TaxonomixTest" => ["test_.used_organization_ids_can_work_with_array_of_organizations"],
    #bunch of broken tests, various causes
                    "UserTest" => ["test_when_a_user_logs_in,_last_login_time_should_be_updated",
                                   "test_return_organization_and_child_ids_for_non-admin_user",
                                   "test_#ensure_last_admin_is_not_deleted_with_non-admins",
                                   "test_can_search_users_by_role_id"],
                    "UsergroupTest" => ["test_delete_user_if_not_in_LDAP_directory",
                                        "test_add_user_if_in_LDAP_directory",
                                        "test_hosts_should_be_retrieved_from_recursive/complex_usergroup_definitions",
                                        "test_cannot_be_destroyed_when_in_use_by_a_host",
                                        "test_add_users_is_case_insensitive_and_does_not_add_nonexistent_users",
                                        "test_remove_users_removes_user_list_and_is_case_insensitive"],
    })
  end
end
