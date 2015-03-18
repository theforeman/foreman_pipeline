angular.module('ForemanPipeline.jenkins-project-params').factory('JenkinsProjectParam',
    ['BastionResource', 'CurrentOrganization', 
    function (BastionResource, CurrentOrganization) {

        return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jenkins_project_params/:id/:action',
            {id: '@id', organizationId: CurrentOrganization}, {

                update: {method: 'PUT'},
        });
    }]
);