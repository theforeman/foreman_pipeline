angular.module('ForemanPipeline.jobs').factory('Job',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        var transformPaths = function (data) {
            return _.map(angular.fromJson(data)["results"], function (path) {
                return _.map(path["environments"], function (env) {
                    return env;
                });
            })
            
        };

        return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jobs/:id/:action',
         {id: '@id', organizationId: CurrentOrganization}, {
          
            update: {method: 'PUT'},
            setContentView: {method: 'PUT', params: {action: 'set_content_view'}},
            setHostgroup: {method: 'PUT', params: {action: 'set_hostgroup'}},
            setJenkins: {method: 'PUT', params: {action: 'set_jenkins'}},
            setResource: {method: 'PUT', params: {action: 'set_resource'}},
            setEnvironment: {method: 'PUT', params: {action: 'set_environment'}},
            availableResources: {method: 'GET', params: {action: 'available_resources'}, transformResponse: function (response) {                
                return {results: angular.fromJson(response)};
            }},
            runJob: {method: 'GET', params: {action: 'run_job'}},
            projects: {method: 'GET', transformResponse: function (response) {
                var job = angular.fromJson(response);
                return {results: job.jenkins_projects};
            }},
            addProjects: {method: 'PUT', params: {action: 'add_projects'}},
            removeProjects: {method: 'PUT', params: {action: 'remove_projects'}},
            addPaths: {method: 'PUT', params: {action: 'add_paths'}},
            removePaths: {method: 'PUT', params: {action: 'remove_paths'}},
            availablePaths: {method: 'GET', params: {action: 'available_paths'}, transformResponse: function (response) {
                return {results: transformPaths(response)};
            }},
            currentPaths: {method: 'GET', params: {action: 'current_paths'}, transformResponse: function (response) {
                return {results: transformPaths(response)};
            }},
            availableEnvironments: {method: 'GET',
                                    params: {action: 'current_paths'},
                                    isArray: true,
                                    transformResponse: function (response) {
                                        return transformPaths(response);
            }},
        });
    }]
);

angular.module('ForemanPipeline.jobs').factory('Hostgroup',
    ['BastionResource',
    function (BastionResource) {

        return BastionResource('/../api/v2/hostgroups/:id/:action',
            {id: '@id'}, {});
    }]
);