angular.module('Integration.jenkins-instances').factory('JenkinsInstance',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../integration/api/organizations/:organizationId/jenkins_instances/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {

                update: {method: 'PUT'}
            })
    }]
);