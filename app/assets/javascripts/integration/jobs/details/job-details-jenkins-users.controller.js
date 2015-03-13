angular.module('Integration.jobs').controller('JobDetailsJenkinsUsersController', 
    ['$scope', '$q', 'translate', 'Job', 'JenkinsUser', 'Nutupane', 
        function ($scope, $q, translate, Job, JenkinsUser, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            var nutupane, params, destroy;

            params = {
                'sort_by': 'name',
                'sort_order': 'ASC',
                'jenkins_instance_id': $scope.$stateParams.jenkinsInstanceId
            };

            nutupane = new Nutupane(JenkinsUser, params)
            $scope.nutupane = nutupane;
            $scope.jUserTable = nutupane.table;
            $scope.removeRow = nutupane.removeRow;


            $scope.destroy = function (jenkinsUser) {
                console.log(jenkinsUser)
                JenkinsUser.remove(jenkinsUser, function () {
                    $scope.successMessages.push(translate('Jenkins User "%s" has been deleted.').replace('%s', jenkinsUser.name));
                    // console.log($scope.jUserTable)
                    $scope.removeRow(jenkinsUser.id);
                    console.log($scope.nutupane)
                });
            };

        }
]);