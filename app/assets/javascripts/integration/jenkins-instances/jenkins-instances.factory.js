angular.module('ForemanPipeline.jenkins-instances').factory('JenkinsInstance',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../integration/api/organizations/:organizationId/jenkins_instances/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {

                update: {method: 'PUT'},
                checkJenkins: {method: 'GET', params: {action: 'check_jenkins'}},
            })
    }]
);