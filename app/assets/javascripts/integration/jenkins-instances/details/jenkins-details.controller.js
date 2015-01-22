angular.module('Integration.jenkins-instances').controller('JenkinsInstanceDetailsController', 
    ['$scope', '$state', 'JenkinsInstance', 
    function ($scope, $state, JenkinsInstance) {

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
    }]
);