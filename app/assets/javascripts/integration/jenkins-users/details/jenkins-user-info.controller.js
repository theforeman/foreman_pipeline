angular.module('Integration.jenkins-users').controller('JenkinsUserInfoController',
    ['$scope', '$q', 'translate', 'JenkinsUser', 
    function ($scope, $q, translate, JenkinsUser) {
        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.panel = $scope.panel || {loading: false};

        $scope.jenkinsUser = $scope.jenkinsUser || JenkinsUser.get({id: $scope.$stateParams.jenkinsUserId}, function () {
            $scope.panel.loading = false;
        });

        $scope.save = function (jenkinsUser) {
            var success,
                error,
                deferred = $q.defer();

            success = function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('Jenkins User updated.'))
            }

            error = function (response) {
                deferred.reject(response);
                angular.forEach(response.data.errors, function (errorMessage, key) {
                    if (angular.isString(key)) {
                        errorMessage = [key, errorMessage].join(' ');
                    }
                    $scope.errorMessages.push(translate('Error occured while saving the Jenkins User: ') + errorMessage);
                });
            }

            jenkinsUser.$update(success, error);
            return deferred.promise;
        };

    }
]);