angular.module('Integration.integration').controller('TestDetailsController', 
    ['$scope', '$state', 'Test', 
    function ($scope, $state, Test) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        if ($scope.test) {
            $scope.panel = {loading: false};
        } else {
            $scope.panel = {loading: true};
        }

        $scope.test = Test.get({id: $scope.$stateParams.testId}, function () {
            $scope.panel.loading = false;
        });
    }]
);