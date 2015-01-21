angular.module('Integration.tests', [
    'ngResource',
    'Bastion.components',
    'ui.router',
    'Bastion'
]);

angular.module('Integration.tests').config(['$stateProvider', function ($stateProvider) {
    $stateProvider.state('tests', {
        abstract: true,
        controller: 'TestsController',
        templateUrl: 'integration/tests/views/tests.html'
    })
    .state('tests.index', {
        url: '/tests',
        permission: 'view_tests',
        views: {
            'table': {
                templateUrl: 'integration/tests/views/tests-table-full.html'
            }
        }
    })
    .state('tests.new', {
        url: '/tests/new',
        permission: 'create_tests',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'integration/tests/views/tests-table-collapsed.html'
            },
            'action-panel': {
                controller: 'NewTestController',
                templateUrl: 'integration/tests/new/views/new-test.html'
            },
            'test-form@tests.new': {
                controller: 'NewTestController',
                templateUrl: 'integration/tests/new/views/new-test-form.html'           
            }
        }
    })
    .state('tests.details', {
        abstract: true,
        url: '/tests/:testId',
        permission: 'view_tests',
        collapsed: true,
        views: {
            'table': {
                templateUrl: 'integration/tests/views/tests-table-collapsed.html'
            },
            'action-panel': {
                controller: 'TestDetailsController',
                templateUrl: 'integration/tests/details/views/test-details.html'
            }
        }
    })
    .state('tests.details.info', {
        url: '/info',
        permission: 'edit_tests',
        collapsed: true,
        controller: 'TestDetailsInfoController',
        templateUrl: 'integration/tests/details/views/test-details-info.html'
    })

}]);