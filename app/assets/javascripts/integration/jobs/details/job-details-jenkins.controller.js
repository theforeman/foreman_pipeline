angular.module('Integration.jobs').controller('JobDetailsJenkinsController',
    ['$scope', '$q', '$location','translate', 'Job', 'JenkinsInstance', 'Nutupane', 
        function ($scope, $q, $location, translate, Job, JenkinsInstance, Nutupane) {

            $scope.successMessages = [];
            $scope.errorMessages = [];

            params = {
                'search': $location.search().search || "",
                'sort_by': 'name',
                'sort_order': 'ASC',
            };

            $scope.job = $scope.job || Job.get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            var nutupane = new Nutupane(JenkinsInstance, params);
            $scope.jenkinsTable = nutupane.table;        
            $scope.nutupane = nutupane;
            nutupane.query();
            
            $scope.setJenkins = function () {
                var success,
                    error,
                    deferred = $q.defer();

                    $scope.chosen = $scope.jenkinsTable.chosenRow;
                    data = {jenkins_instance_id: $scope.chosen.id};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate('New Jenkins Instance successfully set.'));                        
                        nutupane.refresh();
                        $scope.job.jenkins_instance = $scope.chosen;
                        $scope.jenkinsTable.chosenRow = null;
                        $scope.jenkinsTable.working = false;
                    };                 

                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving Job: ') + errorMessage);
                        });
                        $scope.jenkinsTable.working = false;
                    };

                    $scope.jenkinsTable.working = true;
                    Job.setJenkins({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };          
        }
    ]);