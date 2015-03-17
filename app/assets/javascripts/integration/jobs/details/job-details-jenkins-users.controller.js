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
                    if (jenkinsUser.id === $scope.job.jenkins_user.id) {
                        $scope.job.jenkins_user = null;
                    };
                    $scope.removeRow(jenkinsUser.id);
                });
            };

            $scope.setJenkinsUser = function () {
                var success,
                    error,
                    deferred = $q.defer();

                    $scope.chosen = $scope.jUserTable.chosenRow;
                    data = {jenkins_user_id: $scope.chosen.id};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate('New Jenkins User successfully set.'));                        
                        nutupane.refresh();
                        $scope.job.jenkins_user = $scope.chosen;
                        $scope.jUserTable.chosenRow = null;
                        $scope.jUserTable.working = false;
                    };                 

                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving Job: ') + errorMessage);
                        });
                        $scope.jUserTable.working = false;
                    };

                    $scope.jUserTable.working = true;
                    Job.setJenkinsUser({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };

        }
]);