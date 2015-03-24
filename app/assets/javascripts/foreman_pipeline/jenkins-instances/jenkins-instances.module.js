angular.module('ForemanPipeline.jenkins-instances', [
    'ngResource',
    'Bastion.components',
    'ui.router',
    'Bastion'
]);

angular.module('ForemanPipeline.jenkins-instances').config(['$stateProvider', function ($stateProvider) {
    $stateProvider.state('jenkins-instances', {
        abstract: true,
        controller: 'JenkinsInstancesController',
        templateUrl: 'foreman_pipeline/jenkins-instances/views/jenkins-instances.html'
    })
    .state('jenkins-instances.index', {
        url: '/jenkins_instances',
        permission: 'view_jenkins_instances',
        views: {
            'table': {
                templateUrl: 'foreman_pipeline/jenkins-instances/views/jenkins-instances-table-full.html'
            }
        }
    })
    .state('jenkins-instances.new',{
        url: '/jenkins_instances/new',
        permission: 'create_jenkins_instances',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'foreman_pipeline/jenkins-instances/views/jenkins-instances-table-collapsed.html'
            },
            'action-panel': {
                controller: 'NewJenkinsInstanceController',
                templateUrl: 'foreman_pipeline/jenkins-instances/new/views/new-jenkins-instance.html'
            },
            'jenkins-instance-form@jenkins-instances.new': {
                controller: 'NewJenkinsInstanceController',
                templateUrl: 'foreman_pipeline/jenkins-instances/new/views/new-jenkins-instance-form.html'
            }
        }

    })
    .state('jenkins-instances.details', {
        abstract: true,
        url: '/jenkins_instances/:jenkinsInstanceId',
        permission: 'view_jenkins_instances',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'foreman_pipeline/jenkins-instances/views/jenkins-instances-table-collapsed.html'
            },
            'action-panel': {
                controller: 'JenkinsInstanceDetailsController',
                templateUrl: 'foreman_pipeline/jenkins-instances/details/views/jenkins-instance-details.html'
            }
        }
    })
    .state('jenkins-instances.details.info', {
        url: '/info',
        permission: 'edit_jenkins_instances',
        collapsed: true,
        controller: 'JenkinsInstanceDetailsInfoController',
        templateUrl: 'foreman_pipeline/jenkins-instances/details/views/jenkins-instance-details-info.html'
    })

    .state('jenkins-instances.details.users', {
        abstract: true,
        collapsed: true,
        template: '<div ui-view></div>'
    })
    .state('jenkins-instances.details.users.list', {
        url: '/jenkins_users',
        permission: 'view_jenkins_users',
        collapsed: true,
        controller: 'JenkinsInstanceDetailsJenkinsUsersController',
        templateUrl: 'foreman_pipeline/jenkins-instances/details/views/jenkins-instance-details-users.html'
    })
    .state('jenkins-instances.details.users.new', {
        url: '/jenkins_users/new',
        permission: 'create_jenkins_users',
        collapsed: true,
        controller: 'NewJenkinsUserController',
        templateUrl: 'foreman_pipeline/jenkins-users/new/views/new-jenkins-user.html'
    })
    .state('jenkins-instances.details.users.info', {
        url: '/jenkins_users/:jenkinsUserId',
        permission: 'edit_jenkins_users',
        collapsed: true,
        controller: 'JenkinsUserInfoController',
        templateUrl: 'foreman_pipeline/jenkins-users/details/views/jenkins-user-info.html'
    })
    

}]);
