angular.module('Integration.jobs').controller('JobDetailsController',
    ['$scope', '$state', 'Job', function ($scope, $state, Job) {

        
        $scope.successMessages = [];
        $scope.errorMessages = [];
        $scope.isValid = false;

        if ($scope.job) {
            $scope.panel = {loading: false};
        } else {
            $scope.panel = {loading: true};
        }
        
        $scope.job = Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.isValid = $scope.job.content_view !== null 
                                && $scope.job.hostgroup !== null
                                && $scope.job.compute_resource !== null
                                && $scope.job.jenkins_instance !== null;
            console.log($scope.isValid)
            console.log("job: " + $scope.job.name)
            $scope.panel.loading = false;
        });

    }]
);