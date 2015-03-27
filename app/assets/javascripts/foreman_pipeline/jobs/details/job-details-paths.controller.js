angular.module('ForemanPipeline.jobs').controller('JobDetailsPathsController', 
    ['$scope', '$q', 'translate', 'Nutupane', 'Org', 'Organization', 'Job', 'CurrentOrganization', 
    function ($scope, $q, translate, Nutupane, Org, Organization, Job, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

        var params = {
            id: CurrentOrganization
        };

        var nutupane = new Nutupane(Org, params, 'allPaths');
        $scope.nutupane = nutupane;
        $scope.pathsTable = nutupane.table;

        $scope.included = function (path){
            var exec = function (path) {
                if($scope.job.paths.length === 0) {
                    return false;
                } else {
                    var mapped = _.map($scope.job.paths, function (jobPath) {
                        return jobPath.name === path[1].name;
                    });
                    
                    return  _.reduce(mapped, function (memo, num) {
                        return memo || num;
                    });
                }                
            };

            if (typeof ($scope.job.id) === 'undefined'){
                $scope.job.$promise.then(function () {
                    
                    return exec(path);
                });
            } else {
                // console.log(exec(path))
                return exec(path);
            }
            
        };

        $scope.setPaths = function () {
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
                angular.forEach($scope.pathsTable.rows, function (pathInTable) {
                    // $scope.included(pathInTable);
                    console.log($scope.job)
                    console.log($scope.included(pathInTable));
                });
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

        $scope.remove = function (path) {
            var success,
                error,
                deferred = $q.defer(),
                data = {
                    'path_ids': [path[1].id]
                }

            success = function (response) {
                $scope.successMessages.push(translate('Removed %x Environment Path from job %y.')
                    .replace('%x', path[1].name)
                    .replace('%y', $scope.job.name));
                $scope.pathsTable.working = false;
                angular.forEach($scope.pathsTable.rows, function (pathInTable) {
                    $scope.included(pathInTable);
                });
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