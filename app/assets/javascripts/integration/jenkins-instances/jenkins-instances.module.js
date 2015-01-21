angular.module('Integration.jenkins-instances', [
    'ngResource',
    'Bastion.components',
    'ui.router',
    'Bastion'
]);

angular.module('Integration.jenkins-instances').config(['$stateProvider', function ($stateProvider) {
    $stateProvider.state('jenkins-instances', {
        abstract: true,
        controller: 'JenkinsInstancesController',
        templateUrl: 'integration/jenkins-instances/views/jenkins-instances.html'
    })
    .state('jenkins-instances.index', {
        url: '/jenkins_instances',
        permission: 'view_jenkins_instances',
        views: {
            'table': {
                templateUrl: 'integration/jenkins-instances/views/jenkins-instances-table-full.html'
            }
        }
    })
    .state('jenkins-instances.new',{

    })

}]);
