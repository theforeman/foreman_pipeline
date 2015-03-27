angular.module('ForemanPipeline.jobs').controller('JobDetailsAddPathsController', 
    ['$scope', '$q', 'translate', 'Nutupane', 'Job', 'CurrentOrganization', 
    function ($scope, $q, translate, Nutupane, Job, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

        var params = {
            id: $scope.$stateParams.jobId
        }

        var nutupane = new Nutupane(Job, params, 'availablePaths');
        $scope.nutupane = nutupane;
        $scope.pathsTable = nutupane.table;

        $scope.addPaths = function () {
            var data,
                success,
                error,
                deferred = $q.defer(),
                path_ids = _.map($scope.pathsTable.getSelected(), function (item) {
                    return item[1].id;
                });

                data = {
                    'path_ids': path_ids
                };

            success = function (response) {
                $scope.successMessages.push(translate('Added %x Environment Paths to job %y.')
                    .replace('%x', $scope.pathsTable.numSelected)
                    .replace('%y', $scope.job.name));
                $scope.job.paths.push(item[1]); 
                $scope.pathsTable.selectAll(false);
                $scope.pathsTable.working = false;
                deferred.resolve(response);
            };

            error = function (response) {
                deferred.reject(response.data.errors);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                        if (angular.isString(key)) {
                            errorMessage = [key, errorMessage].join(' ');
                        }
                        $scope.errorMessages.push(translate('Error occured while Adding Paths: ') + errorMessage);
                    });
                $scope.pathsTable.working = false;
            };

            $scope.pathsTable.working = true;
            Job.setPaths({id: $scope.job.id}, data, success, error);
            return deferred.promise;
        };

    }]
)