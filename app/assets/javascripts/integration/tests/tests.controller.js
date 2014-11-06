angular.module('Integration.integration').controller('TestsController', 
    ['$scope', 'translate', '$location', 'Nutupane', 'Test', 'CurrentOrganization',
    function ($scope, translate, $location, Nutupane, Test, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        params = {
            'search': $location.search().search || "",
            'sort_by': 'name',
            'sort_order': 'ASC'
        };

        var nutupane = new Nutupane(Test, params);
        $scope.testsTable = nutupane.table;
        $scope.removeRow = nutupane.removeRow;
        $scope.nutupane = nutupane;
        $scope.table = $scope.testsTable;

        $scope.testsTable.closeItem = function () {
            $scope.transitionTo('tests.index');
        };

        $scope.deleteTest = function (test) {
            test.$remove(function () {
                $scope.successMessages.push(translate('Test %s has been deleted.').replace('%s', test.name));
                $scope.removeRow(test.id);
                $scope.transitionTo('tests.index');
            });
        };
    }]
);