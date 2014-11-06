angular.module('Integration.integration').controller('JobDetailsController',
    ['$scope', '$state', 'Job', function ($scope, $state, Job) {

        
        $scope.successMessages = [];
        $scope.errorMessages = [];

        if ($scope.job) {
            $scope.panel = {loading: false};
        } else {
            $scope.panel = {loading: true};
        }
        
        $scope.job = Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

    }]
);