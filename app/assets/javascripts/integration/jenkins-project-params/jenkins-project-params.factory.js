angular.module('Integration.jenkins-project-params').factory('JenkinsProjectParam',
    ['BastionResource', 'CurrentOrganization', 
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../integration/api/organizations/:organizationId/jenkins_project_params/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {

                update: {method: 'PUT'},
        });
    }]
);