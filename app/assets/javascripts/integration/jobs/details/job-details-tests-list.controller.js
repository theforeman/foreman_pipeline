angular.module('Integration.jobs').controller('JobDetailsTestsListController', 
    ['$scope', '$q', '$location', 'translate', 'Nutupane', 'Job',
        function ($scope, $q, $location, translate, Nutupane, Job) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            var params = {
                'serach': $location.search().search || "",
                'sort_by': 'name',
                'sort_order': 'ASC',
                'id': $scope.$stateParams.jobId
            }

            var nutupane = new Nutupane(Job, params, 'tests');
            $scope.testsTable = nutupane.table;

            $scope.removeTests = function () {
                var data,
                    success,
                    error,
                    deferred = $q.defer(),
                    testsToRemove = _.pluck($scope.testsTable.getSelected(), 'id');

                data = {
                    'test_ids': testsToRemove
                };

                success = function (response) {
                    $scope.successMessages.push(translate('Removed %x tests from Job: %y.')
                        .replace('%x', $scope.testsTable.numSelected).replace('%y', $scope.job.name));
                    $scope.testsTable.working = false;
                    $scope.testsTable.selectAll(false);
                    nutupane.refresh();
                    $scope.job.$get();
                    deferred.resolve(response);
                };

                error = function (response) {
                    deferred.reject(response);
                    $scope.errorMessages = response.data.errors;
                    $scope.testsTable.working = false;
                };

                $scope.testsTable.working = true;
                Job.removeTests({id: $scope.job.id}, data, success, error);
                return deferred.promise;
            };
        }]
);