angular.module('Integration.jobs').factory('Job',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../integration/api/organizations/:organizationId/jobs/:id/:action',
         {id: '@id', organizationId: CurrentOrganization}, {
          
            update: {method: 'PUT'},
            setContentView: {method: 'PUT', params: {action: 'set_content_view'}},
            setHostgroup: {method: 'PUT', params: {action: 'set_hostgroup'}},
            removeTests: {method: 'PUT', params: {action: 'remove_tests'}},
            addTests: {method: 'PUT', params: {action: 'add_tests'}},
            availableTests: {method: 'GET', params: {action: 'available_tests'}},
            tests: {method: 'GET', transformResponse: function (response) {
                var job = angular.fromJson(response);
                return {results: job.tests};
            }},
          
        });
    }]
);

angular.module('Integration.jobs').factory('Hostgroup',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../api/v2/hostgroups/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {});
    }]
);