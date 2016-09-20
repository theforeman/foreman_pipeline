angular.module('ForemanPipeline.jenkins-instances').controller('JenkinsInstanceDetailsInfoController',
    ['$scope', '$q', 'translate', 'JenkinsInstance',
    function ($scope, $q, translate, JenkinsInstance) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.panel = $scope.panel || {loading: false};

        $scope.jenkinsInstance = $scope.jenkinsInstance || JenkinsInstance.get({id: $scope.$stateParams.jenkinsInstanceId}, function () {
            $scope.panel.loading = false;
        });

        $scope.save = function (jenkinsInstance) {
            var success,
                error,
                deferred = $q.defer();

            success = function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('Jenkins Instance updated.'))
            }

            error = function (response) {
                deferred.reject(response);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                    if (angular.isString(key)) {
                        errorMessage = [key, errorMessage].join(' ');
                    }
                    $scope.errorMessages.push(translate('Error occured while saving the Jenkins Instance: ') + errorMessage);
                });
            }

            jenkinsInstance.$update(success, error);
            return deferred.promise;
        };

        $scope.$on('successMessages', function (event, data) {
            $scope.successMessages = data;
        });
        $scope.$on('errorMessages', function (event, data) {
            $scope.errorMessages = data;
        });

        $scope.checkJenkins = function () {
            var deferred = $q.defer();
            $scope.working = true;
            JenkinsInstance.checkJenkins({id: $scope.jenkinsInstance.id}, function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('Jenkins is reachable, server ver. %s').replace('%s', response.server_version));
                $scope.$broadcast('successMessages', $scope.successMessages)
                $scope.working = false;
            }, function (response) {
                deferred.reject(response);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                        if (angular.isString(key)) {
                            errorMessage = [key, errorMessage].join(' ');
                        }
                        $scope.errorMessages.push(translate("Could not reach Jenkins server: ") + errorMessage);
                        $scope.$broadcast('errorMessages', $scope.errorMessages);
                    });
                $scope.working = false;
            })
            return deferred.promise;
        };
    }]
);