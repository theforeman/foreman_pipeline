angular.module('Integration.jobs').controller('JobDetailsToEnvironmentController',
    ['$scope', '$q', 'Organization', 'Job', 'translate', 'CurrentOrganization', 'Org',
        function ($scope, $q, Organization, Job, translate, CurrentOrganization, Org) {

            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.environments = [];

            $scope.job = $scope.job || Job.$get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            $scope.chosenEnvironment = $scope.job.environment;

            $scope.loading = true;            

            $scope.environments = Org.firstPath({id: CurrentOrganization}, function () {
                $scope.loading = false;
            });

            $scope.setEnvironment = function () {
                var success, 
                    error,
                    deferred = $q.defer();                    
                    data = {environment_id: $scope.chosenEnvironment.id};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate("New Lifecycle Environmnet successfully set."))
                        $scope.working = false;
                        $scope.job.environment = $scope.chosenEnvironment;
                    };

                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving the Job: ' + errorMessage));
                        });
                        $scope.working = false;
                    };

                    $scope.working = true;
                    Job.setEnvironment({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };
        }]
);