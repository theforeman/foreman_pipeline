angular.module('Integration.integration').controller('NewTestController',
    ['$scope', 'translate', 'Test', 
    function ($scope, translate, Test) {

        $scope.successMessages = [];
        $scope.test = new Test();

        var success = function (test) {
            $scope.working = false;
            $scope.successMessages = [translate('New Test successfully creted.')];

            if ($scope.testsTable) {
                $scope.testsTable.rows.unshift(test);
            }
            $scope.transitionBack();
        };

        var error = function (response) {
            $scope.working = false;
            angular.forEach(response.data.errors, function (errors, field) {
                $scope.testForm[field].$setValidity('server', false);
                $scope.testForm[field].$error.messages = errors;
            });
        };

        $scope.createTest = function (test) {
            test.$save(success, error);
        };



    }]
);