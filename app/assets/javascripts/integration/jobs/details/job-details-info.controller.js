angular.module('Integration.integration').controller('JobDetailsInfoController', 
    ['$scope', '$q', 'translate', 'Job', 'MenuExpander', 
        function ($scope, $q, translate, Job, MenuExpander) {

            
            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.menuExpander = MenuExpander;

            $scope.panel = $scope.panel || {loading: false};

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

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
        }]
);