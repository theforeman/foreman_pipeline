angular.module('Integration.jenkins-users').controller('NewJenkinsUserController', 
    ['$scope', '$q', 'translate', 'JenkinsUser', 'Job',
        function ($scope, $q, translate, JenkinsUser, Job) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            $scope.jenkinsUser = new JenkinsUser();
            var success, error;

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            success = function (response) {
                $scope.working = false;
                $scope.successMessages.push(translate('New Jenkins User successfully created'))
                $scope.$state.go('jobs.details.jenkins-users.list', {jobId: $scope.job.id});
            };

            error = function (response) {
                $scope.working = false;
                angular.forEach(response.data.errors, function (errors, field) {
                    try {
                        $scope.jenkinsInstanceForm[field].$setValidity('server', false);
                        $scope.jenkinsInstanceForm[field].$error.messages = errors;    
                    } 
                    catch (err) {
                        $scope.errorMessages.push(errors);
                    }
                    
                });
            };

            $scope.createJenkinsUser = function (jenkinsUser) {
                jenkinsUser.job_id = $scope.job.id;
                jenkinsUser.$save(success, error);
            };

            $scope.transitionBack = function () {
                $scope.$state.go('jobs.details.jenkins-instances.jenkins-users.list',
                 {jobId: $scope.job.id, jenkinsInstanceId: $scope.job.jenkins_instance.id});
            };

    }]
);