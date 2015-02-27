angular.module('Integration.jenkins-requests').factory('JenkinsRequest', 
    ['BastionResource', 'CurrentOrganization', 
        function (BastionResource, CurrentOrganization) {

            return BastionResource('/../integration/api/organizations/:organizationId/jenkins_requests/:action',
                {id: '@id', organizationId: CurrentOrganization}, {
                    
                    list: {method: 'POST', params: {action: 'list'}},
                                       
                })
        }]);