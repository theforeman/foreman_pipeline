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
    }]
);