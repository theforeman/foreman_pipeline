angular.module('ForemanPipeline.jobs').controller('JobDetailsResourcesController', 
    ['$scope', '$q', '$location', '$window', 'translate', 'Job', 'Nutupane', 
        function ($scope, $q, $location, $window, translate, Job, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];        

            params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'order': 'ASC',
                'id': $scope.$stateParams.jobId,
            };

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });        

            var nutupane = new Nutupane(Job, params, 'availableResources');
            $scope.nutupane = nutupane;
            $scope.table = nutupane.table;
            nutupane.query();

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

            $scope.transitionToResource = function (resource) {
                $window.location.href = '/compute_resources/' + resource.id 
            };
        } 
]);