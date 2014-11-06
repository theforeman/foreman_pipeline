angular.module('Integration.integration').controller('NewJobController', 
    ['$scope', 'translate', 'Job', function ($scope, translate, Job) {

        $scope.successMessages = [];

        $scope.job = new Job();

        $scope.createJob = function (job) {            
            
            job.$save(success, error);
        };

        function success (job) {
            $scope.working = false;
            $scope.successMessages = [translate('New job successfully created.')];

            if ($scope.jobsTable) {
                $scope.jobsTable.rows.unshift(job);
            }
            $scope.transitionBack();
        }

        function error (response) {
            $scope.working = false;
            angular.forEach(response.data.errors, function (errors, field) {
                $scope.jobForm[field].$setValidity('server', false);
                $scope.jobForm[field].$error.messages = errors;
            });
        }
    }]
);