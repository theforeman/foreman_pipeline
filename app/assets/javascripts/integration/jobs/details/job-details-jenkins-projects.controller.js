angular.module('Integration.jobs').controller('JobDetailsJenkinsProjectsController',
    ['$scope', '$q', 'translate', 'Nutupane', 'Job', 
        function ($scope, $q, translate, Nutupane, Job) {

            $scope.errorMessages = [];
            $scope.successMessages = [];

            params = {
                'sort_by': 'name',
                'sort_order': 'ASC',
                'id': $scope.$stateParams.jobId
            } 

            nutupane = new Nutupane(Job, params, 'projects');
            $scope.nutupane = nutupane;
            $scope.projectsTable = nutupane.table;
        }]);