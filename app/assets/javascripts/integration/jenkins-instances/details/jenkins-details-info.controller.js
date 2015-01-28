angular.module('Integration.jenkins-instances').controller('JenkinsInstanceDetailsInfoController', 
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
                angular.forEach(response.data.erorrs, function (errorMessage, key) {
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
        
    }]
);