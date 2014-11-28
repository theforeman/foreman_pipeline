angular.module('Integration.jobs').controller('JobDetailsHostgroupsController',
    ['$scope', '$q', '$location', 'translate', 'Job', 'Hostgroup', 'Nutupane', 
        function ($scope, $q, $location, translate, Job, Hostgroup, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'order': 'ASC' 
            }

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            })

            var nutupane = new Nutupane(Hostgroup);
            $scope.nutupane = nutupane;
            $scope.hostgroupsTable = nutupane.table;

            $scope.setHostgroup = function () {
                var success,
                    error,
                    deferred = $q.defer();

                    $scope.chosen = $scope.hostgroupsTable.chosenRow;
                    data = {hostgroup_id: $scope.chosen.id};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate("New Hostgroup successfully set, don't forget to set new Compute Resource in the following tab."));
                        $scope.hostgroupsTable.working = false;
                        nutupane.refresh();
                        $scope.job.hostgroup = $scope.chosen;
                        $scope.job.compute_resource = null;
                    };

                    error = function () {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving the Job: ' + errorMessage));
                        });
                        $scope.hostgroupsTable.working = false;
                    };

                    $scope.hostgroupsTable.working = true;
                    Job.setHostgroup({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };

            
        }
    ]);