angular.module('ForemanPipeline.jenkins-requests').factory('JenkinsRequest', 
    ['BastionResource', 'CurrentOrganization', 
        function (BastionResource, CurrentOrganization) {

            return BastionResource('/../foreman_pipeline/api/organizations/:organizationId/jenkins_requests/:action',
                {id: '@id', organizationId: CurrentOrganization}, {
                    
                    list: {method: 'GET', params: {action: 'list'}},
                    getBuildParams: {method: 'GET', params: {action: 'get_build_params'}}           
                })
        }]);