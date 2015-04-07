angular.module('ForemanPipeline.jobs').controller('JobDetailsPathsController', 
    ['$scope', '$q', 'translate', 'Nutupane', 'Org', 'Organization', 'Job', 'CurrentOrganization', 
    function ($scope, $q, translate, Nutupane, Org, Organization, Job, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

        var params = {
            id: $scope.$stateParams.jobId
        };

        var nutupane = new Nutupane(Job, params, 'currentPaths');
        $scope.nutupane = nutupane;
        $scope.pathsTable = nutupane.table;


        $scope.removePaths = function () {
            var success,
                error,
                deferred = $q.defer(),
                path_ids = _.map($scope.pathsTable.getSelected(), function (item) {
                    return item[1].id;
                });
                data = {
                    'path_ids': path_ids
                }

            success = function (response) {
                $scope.successMessages.push(translate('Removed %x Environment Paths from job %y.')
                    .replace('%x', $scope.pathsTable.numSelected)
                    .replace('%y', $scope.job.name));
                if (response.environment === null) {
                    $scope.$emit('envNull')                
                }
                $scope.job.paths = _.difference($scope.job.paths, $scope.pathsTable.getSelected());
                $scope.pathsTable.rows = _.difference($scope.pathsTable.rows, $scope.pathsTable.getSelected());
                $scope.pathsTable.working = false;
                $scope.pathsTable.selectAll(false);
                deferred.resolve(response);
            };

            error = function (response) {
                deferred.reject(response.data.errors);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                        if (angular.isString(key)) {
                            errorMessage = [key, errorMessage].join(' ');
                        }
                        $scope.errorMessages.push(translate('Error occured while Removing Paths: ') + errorMessage);
                    });
                $scope.pathsTable.working = false;
            };

            $scope.pathsTable.working = true;
            Job.removePaths({id: $scope.job.id}, data, success, error);
            return deferred.promise;
        };

    }
])