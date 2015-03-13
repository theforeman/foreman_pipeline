angular.module('Integration.jobs').controller('JobDetailsJenkinsUsersController', 
    ['$scope', '$q', 'translate', 'Job', 'JenkinsUser', 'Nutupane', 
        function ($scope, $q, translate, Job, JenkinsUser, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
                params['jenkins_instance_id'] = $scope.job.jenkins_instance.id;
            });

            params = {
                'sort_by': 'name',
                'sort_order': 'ASC',
            };

            var nutupane = new Nutupane(JenkinsUser, params)
            $scope.nutupane = nutupane;
            $scope.jUserTable = nutupane.table;

        }
]);