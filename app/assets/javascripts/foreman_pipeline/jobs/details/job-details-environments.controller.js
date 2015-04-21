angular.module('ForemanPipeline.jobs').controller('JobDetailsEnvironmentsController', 
    ['$scope', '$q', 'translate', 'Job', 'CurrentOrganization',
    function ($scope, $q, translate, Job, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
            $scope.panel.loading = false;
        });

        var params = {
            organization_id: CurrentOrganization,
            id: $scope.$stateParams.jobId,
            all_paths: true,
        };

        $scope.loading = true;

        $scope.chosenEnvironment = $scope.job.environment;

        $scope.environments = Job.availableEnvironments(params, function () {
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
                        $scope.job.to_environments = [];
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
    }
])