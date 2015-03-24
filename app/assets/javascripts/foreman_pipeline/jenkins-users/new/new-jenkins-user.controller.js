angular.module('ForemanPipeline.jenkins-users').controller('NewJenkinsUserController', 
    ['$scope', '$q', 'translate', 'JenkinsUser', 'JenkinsInstance',
        function ($scope, $q, translate, JenkinsUser, JenkinsInstance) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            $scope.jenkinsUser = new JenkinsUser();
            var success, error;

            $scope.jenkinsInstance = $scope.jenkinsInstance || JenkinsInstance.get({id: $scope.$stateParams.jenkinsInstanceId}, function () {
                $scope.panel.loading = false;
            });

            success = function (response) {
                $scope.working = false;
                $scope.successMessages.push(translate('New Jenkins User successfully created'))
                $scope.transitionBack();
            };

            error = function (response) {
                $scope.working = false;
                angular.forEach(response.data.errors, function (errors, field) {
                    try {
                        $scope.jenkinsUsereForm[field].$setValidity('server', false);
                        $scope.jenkinsUserForm[field].$error.messages = errors;    
                    } 
                    catch (err) {
                        $scope.errorMessages.push(errors);
                    }
                    
                });
            };

            $scope.createJenkinsUser = function (jenkinsUser) {
                jenkinsUser.jenkinsInstance_id = $scope.jenkinsInstance.id;
                jenkinsUser.$save(success, error);
            };

            $scope.transitionBack = function () {
                $scope.$state.go('jenkins-instances.details.users.list',
                 {jenkinsInstanceId: $scope.jenkinsInstance.id});
            };

    }]
);