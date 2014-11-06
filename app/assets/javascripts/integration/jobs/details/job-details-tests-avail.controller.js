angular.module('Integration.integration').controller('JobDetailsTestsAvailController',
    ['$scope', '$q', '$location', 'translate', 'Nutupane', 'Job', 
        function ($scope, $q, $location, translate, Nutupane, Job) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'sort_order': 'ASC',
                'id': $scope.$stateParams.jobId
            };

            nutupane = new Nutupane(Job, params, 'availableTests');
            $scope.testsTable = nutupane.table;

            $scope.addTests = function () {
                var data,
                    success,
                    error,
                    deferred = $q.defer(),
                    tests = _.pluck($scope.testsTable.getSelected(), 'id');

                    data = {
                        'test_ids': tests
                    };

                success = function (response) {
                    $scope.successMessages.push(translate('Added %x tests to job %y.')
                        .replace('%x', $scope.testsTable.numSelected)
                        .replace('%y', $scope.job.name));
                    $scope.testsTable.working = false;
                    $scope.testsTable.selectAll(false);
                    nutupane.refresh();
                    $scope.job.$get();
                    deferred.resolve(response);
                };

                error = function (response) {
                    deferred.reject(response.data.errors);
                    $scope.errorMessages = response.data.errors;
                    $scope.testsTable.working = false;
                };

                $scope.testsTable.working = true;
                Job.addTests({id: $scope.job.id}, data, success, error);
                return deferred.promise;
            };
        }]
);