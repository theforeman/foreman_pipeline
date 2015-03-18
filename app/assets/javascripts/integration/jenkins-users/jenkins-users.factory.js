angular.module('ForemanPipeline.jenkins-users').factory('JenkinsUser',
    ['BastionResource', 'CurrentOrganization', 
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jenkins_users/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {
                update: {method: 'PUT'},
        });
    }]
);