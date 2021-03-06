angular.module('ForemanPipeline.jenkins-instances').factory('JenkinsInstance',
    ['BastionResource', 'CurrentOrganization',
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jenkins_instances/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {

                update: {method: 'PUT'},
                checkJenkins: {method: 'GET', params: {action: 'check_jenkins'}},
                setJenkinsUser: {method: 'PUT', params: {action: 'set_jenkins_user'}},
                
            })
    }]
);