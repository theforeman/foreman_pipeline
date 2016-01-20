angular.module('ForemanPipeline.jobs', [
    'ngResource',
    'Bastion.components',
    'ui.router',
    'Bastion',
]);

angular.module('ForemanPipeline.jobs').config(['$stateProvider', function ($stateProvider) {
    $stateProvider.state('jobs', {
        abstract: true,
        controller: 'JobsController',
        templateUrl: 'jobs/views/jobs.html'
    })
    .state('jobs.index', {
        url: '/jobs',
        permission: 'view_jobs',
        views: {
            'table': {
                templateUrl: 'jobs/views/jobs-table-full.html'
            }
        }
    })
    .state('jobs.new', {
        url: '/jobs/new',
        permission: 'create_jobs',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'jobs/views/jobs-table-collapsed.html'
            },
            'action-panel': {
                controller: 'NewJobController',
                templateUrl: 'jobs/new/views/new-job.html'
            },
            'job-form@jobs.new': {
                controller: 'NewJobController',
                templateUrl: 'jobs/new/views/new-job-form.html'
            }
        }
    })
    .state('jobs.details', {
        abstract: true,
        url: '/jobs/:jobId',
        permission: 'view_jobs',
        collapsed: true,
        views: {
            'table': {
                  templateUrl: 'jobs/views/jobs-table-collapsed.html'
            },
            'action-panel': {
                  controller: 'JobDetailsController',
                  templateUrl: 'jobs/details/views/job-details.html'
            }
        }
    })
    .state('jobs.details.info', {
        url: '/info',
        permission: 'edit_jobs',
        collapsed: true,
        controller: 'JobDetailsInfoController',
        templateUrl: 'jobs/details/views/job-details-info.html'
    })
    .state('jobs.details.content-views', {
        url: '/content_views',
        permission: 'edit_jobs',
        collapsed: true,
        controller: 'JobDetailsContentViewsController',
        templateUrl: 'jobs/details/views/job-details-content-views.html'
    })

    .state('jobs.details.hostgroups', {
        url: '/hostgroups',
        permission: 'edit_jobs',
        collapsed: true,
        controller: 'JobDetailsHostgroupsController',
        templateUrl: 'jobs/details/views/job-details-hostgroups.html'
    })

    .state('jobs.details.resources', {
        url: '/resources',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobDetailsResourcesController',
        templateUrl: 'jobs/details/views/job-details-resources.html'
    })

    .state('jobs.details.environments', {
       abstract: true,
       collapsed: true,
       template: '<div ui-view></div>'
    })
    .state('jobs.details.environments.from-environment', {
        url: '/environments',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobDetailsEnvironmentsController',
        templateUrl: 'jobs/details/views/job-details-environments.html'
    })

    .state('jobs.details.environments.to-environments', {
        url: '/environments/to_environments',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobDetailsToEnvironmentsController',
        templateUrl: 'jobs/details/views/job-details-to-environments.html'
    })

    .state('jobs.details.jenkins-instances', {
        url: '/jenkins_instances',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobDetailsJenkinsController',
        templateUrl: 'jobs/details/views/job-details-jenkins.html'
    })
    .state('jobs.details.jenkins-projects', {
        abstract: true,
        collapsed: true,
        templateUrl: 'jobs/details/project-discovery/views/job-jenkins-projects.html'
    })

    .state('jobs.details.jenkins-projects.list', {
        url: '/jenkins_projects',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobDetailsJenkinsProjectsController',
        templateUrl: 'jobs/details/views/job-details-jenkins-projects.html'
    })
    .state('jobs.details.jenkins-projects.discovery', {
        url: '/jenkins_projects/discovery',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobProjectsDiscoveryController',
        templateUrl: 'jobs/details/project-discovery/views/job-projects-discovery.html'
    })
    .state('jobs.details.jenkins-projects.parameters', {
        url: '/jenkins_projects/:projectId',
        collapsed: true,
        permission: 'edit_jobs',
        controller: 'JobProjectsParametersController',
        templateUrl: 'jobs/details/project-discovery/views/job-projects-parameters.html'
    })
}]);
