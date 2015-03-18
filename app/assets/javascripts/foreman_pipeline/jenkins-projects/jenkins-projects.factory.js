angular.module('ForemanPipeline.jenkins-projects').factory('JenkinsProject', 
    ['BastionResource', 'CurrentOrganization', 
        function (BastionResource, CurrentOrganization) {

            return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jenkins_projects/:id/:action',
                {id: '@id', organizationId: CurrentOrganization}, {
                    
                })
        }]);