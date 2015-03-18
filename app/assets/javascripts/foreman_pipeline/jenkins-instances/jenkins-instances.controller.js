angular.module('ForemanPipeline.jenkins-instances').controller('JenkinsInstancesController',
    ['$scope', 'translate', '$location', 'Nutupane', 'JenkinsInstance', 'CurrentOrganization',
    function ($scope, translate, $location, Nutupane, JenkinsInstance, CurrentOrganization) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        params = {
            'search': $location.search().search || "",
            'sort_by': 'name',
            'sort_order': 'ASC'
        }

        var nutupane = new Nutupane(JenkinsInstance, params);
        $scope.jenkinsTable = nutupane.table;
        $scope.removeRow = nutupane.removeRow;
        $scope.nutupane = nutupane;
        $scope.table = $scope.jenkinsTable;

        nutupane.enableSelectAllResults();
        
        $scope.jenkinsTable.closeItem = function () {
            $scope.transitionTo('jenkins-instances.index');
        }

        $scope.deleteJenkinsInstance = function (jenkins) {
            jenkins.$remove(function () {
                $scope.successMessages.push(translate('Jenkins Instance "%s" has been deleted.').replace('%s', jenkins.name));
                $scope.removeRow(jenkins.id);
                $scope.transitionTo('jenkins-instances.index');
            });
        };
    }]
);