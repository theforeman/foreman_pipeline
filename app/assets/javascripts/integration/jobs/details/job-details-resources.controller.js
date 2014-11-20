angular.module('Integration.jobs').controller('JobDetailsResourcesController', 
    ['$scope', '$q', '$location', 'translate', 'Job', 'CompResource', 'Nutupane', 
    function ($scope, $q, $location, translate, Job, CompResource, Nutupane) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        params = {
            'search': $location.search().search || "",
            'sort_by': 'name',
            'order': 'ASC'
        };

        $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

        var nutupane = new Nutupane(CompResource);
        $scope.nutupane = nutupane;
        $scope.table = nutupane.table;

        $scope.setResource = function () {
            var success,
                error,
                deferred = $q.defer();

            $scope.chosen = $scope.table.chosenRow;
            data = {resource_id: $scope.chosen.id};

            success = function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('New resource successfully set.'));
                $scope.table.working = false;
                nutupane.refresh();
                $scope.job.compute_resource = $scope.chosen;
            };

            error = function (response) {
                $q.reject(response);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving the Job: ' + errorMessage));
                        });
                        $scope.table.working = false;
            }

            $scope.table.working = true;
            Job.setResource({id: $scope.job.id}, data, success, error);
            return deferred.promise;
        };
    } 
]);