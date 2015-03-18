angular.module('ForemanPipeline.jenkins-instances').controller('JenkinsInstanceDetailsController', 
    ['$scope', '$state', 'JenkinsInstance', '$q', 'translate',
    function ($scope, $state, JenkinsInstance, $q, translate) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        if ($scope.jenkinsInstance) {
            $scope.panel = {loading: false};
        } else {
            $scope.panel = {loading: true};
        }

        $scope.jenkinsInstance = JenkinsInstance.get({id: $scope.$stateParams.jenkinsInstanceId}, function () {
            $scope.panel.loading = false;
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
                        $scope.broadcast('errorMessages', $scope.errorMessages);
                    });
                $scope.working = false;
            })
            return deferred.promise;
        };
    }]
);