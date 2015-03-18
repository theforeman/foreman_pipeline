angular.module('ForemanPipeline.jobs').controller('JobsController',
    ['$scope', '$location', 'translate', 'Nutupane', 'Job', 'CurrentOrganization', '$window',
        function ($scope, $location, translate, Nutupane, Job, CurrentOrganization, $window) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            var params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'sort_order': 'ASC' 
            };

            var nutupane = new Nutupane(Job, params);
            $scope.jobsTable = nutupane.table;
            $scope.removeRow = nutupane.removeRow;
            $scope.nutupane = nutupane;

            $scope.jobsTable.closeItem = function () {
              $scope.transitionTo('jobs.index');
            };

            nutupane.enableSelectAllResults();

            $scope.table = $scope.jobsTable;

            $scope.deleteJob = function (job) {
                job.$remove(function () {
                    $scope.successMessages.push(translate('Job %s has been deleted.').replace('%s', job.name));
                    $scope.removeRow(job.id);
                    $scope.transitionTo('jobs.index');
                });
            };

            $scope.transitionToHostgroup = function (hostgroup) {
                $window.location.href = '/hostgroups/' + hostgroup.id + '/edit';
            }
        }]
);