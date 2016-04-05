angular.module('ForemanPipeline.jobs').controller('JobDetailsJenkinsProjectsController',
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
            $scope.projectsTable = nutupane.table;
            nutupane.query();

            $scope.removeProjects = function () {
                var data,
                    success,
                    error,
                    deferred = $q.defer(),
                    projectsToRemove = _.pluck($scope.projectsTable.getSelected(), 'id');

                data = {
                    'project_ids': projectsToRemove
                };

                success = function (response) {
                    $scope.successMessages.push(translate('Removed %x projects from Job: %y.')
                        .replace('%x', $scope.projectsTable.numSelected).replace('%y', $scope.job.name));
                    $scope.projectsTable.working = false;
                    $scope.projectsTable.selectAll(false);
                    nutupane.refresh();
                    $scope.job.$get();
                    deferred.resolve(response);
                };

                error = function (response) {
                    deferred.reject(response);
                    $scope.errorMessages = response.data.errors;
                    $scope.projectsTable.working = false;
                };

                $scope.projectsTable.working = true;
                Job.removeProjects({id: $scope.job.id}, data, success, error);
                return deferred.promise;
            };
        }]);