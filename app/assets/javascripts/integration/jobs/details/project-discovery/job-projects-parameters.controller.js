angular.module('ForemanPipeline.jobs').controller('JobProjectsParametersController', 
    ['$scope', '$state', '$q', 'translate', 'JenkinsProjectParam', 'JenkinsProject',
        function ($scope, $state, $q, translate, JenkinsProjectParam, JenkinsProject) {

            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.projectParamsList = [];
            var loadParameters;

            $scope.loading = true;

            loadParameters = function () {                 
                $scope.projectParamsList = _.map($scope.jenkinsProject.jenkins_project_params, function (item) {
                    if(item.type === "boolean") {
                        if(item.value === "t" || item.value === "true") {
                            item.value = true;
                        } else {
                            item.value = false;
                        }
                    }
                    return item
                });
                $scope.loading = false;
            };

            $scope.jenkinsProject = JenkinsProject.get({
                'id': $scope.$stateParams.projectId
            }, loadParameters);

            $scope.save = function (param, index) {
                var success, error,
                    deferred = $q.defer();

                success = function (response) {
                    deferred.resolve(response);
                    $scope.successMessages.push(translate("Parameter %x successfully updated").replace("%x", param.name));

                };

                error = function (response) {
                    deferred.reject(response);
                    angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving Project Param: ') + errorMessage);
                        });
                };
                console.log($scope.projectParamsList)
                JenkinsProjectParam.update({id: param.id}, param, success, error);
                return deferred.promise;
            };
            
    }
]);