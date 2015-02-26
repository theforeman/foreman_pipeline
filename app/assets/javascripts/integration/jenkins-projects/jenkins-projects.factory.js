angular.module('Integration.jenkins-projects').factory('JenkinsProject', 
    ['BastionResource', 'CurrentOrganization', 
        function (BastionResource, CurrentOrganization) {

            return BastionResource('../integration/api/organizations/:organizationId/jenkins_projects/:id/:action',
                {id: '@id', organizationId: CurrentOrganization}, {
                    
                })
        }]);