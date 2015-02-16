angular.module('Integration.jobs').controller('JobDetailsInfoController', 
    ['$scope', '$q', 'translate', 'Job', 'MenuExpander', 
        function ($scope, $q, translate, Job, MenuExpander) {

            
            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.menuExpander = MenuExpander;

            $scope.panel = $scope.panel || {loading: false};
            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
                
            });

            $scope.working = false;

            $scope.isValid = $scope.checkValid();

            $scope.save = function (job) {
                var deferred = $q.defer();
                job.$update(function (response) {
                    deferred.resolve(response);
                    $scope.successMessages.push(translate('Job updated.'));
                }, function (response) {
                    deferred.reject(response);
                    angular.forEach(response.data.errors, function (errorMessage, key) {
                        if (angular.isString(key)) {
                            errorMessage = [key, errorMessage].join(' ');
                        }
                        $scope.errorMessages.push(translate('Error occured while saving Job: ') + errorMessage);
                    });
                });
                return deferred.promise;
            };                      
            
            $scope.runJob = function () {
                var success,
                    error,
                    deferred = $q.defer();

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate("Job %s successfully started.").replace("%s", $scope.job.name));
                        $scope.working = false;
                    };
                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while starting Job: ') + errorMessage);
                        });
                        $scope.working = false;
                    };
                    $scope.working = true;
                    Job.runJob({id: $scope.job.id}, {}, success, error);
                    return deferred.promise;                
            };         
        }]
);