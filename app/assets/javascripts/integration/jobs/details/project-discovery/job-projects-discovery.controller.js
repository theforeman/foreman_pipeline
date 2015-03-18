angular.module('ForemanPipeline.jobs').controller('JobProjectsDiscoveryController',
    ['$scope', '$q', 'translate',  'Job', 'Task', 'JenkinsRequest',
        function ($scope, $q, translate, Job, Task, JenkinsRequest) {

            var setDetails, transformRows;

            $scope.successMessages = [];
            $scope.errorMessages = [];

            $scope.projectsTable = {rows: []};
            $scope.discovery = {pattern: ''}

            updateTask = function (task) {
                setDetails(task);
                if (!task.pending) {
                    Task.unregisterSearch($scope.taskSearchId);
                }
            }

            setDetails = function (task) {
                $scope.discovery.pending = task.pending;
                if (!task.pending) {
                    $scope.discovery.pattern = task.input.filter
                    $scope.projectsTable.rows = transformRows(task.output.projects)
                }
            }

            transformRows = function (project_names) {
                var projects, sorted;
                projects = _.map(project_names, function (item) {
                    return {'name': item}
                });
                
                sorted = _.sortBy(projects, function (item) {
                    return item.name;
                });

                return _.filter(sorted, function (obj) {
                    return !_.findWhere($scope.job.jenkins_projects, obj);
                });
            }

            registerTask = function (task) {
                $scope.taskSearchId = Task.registerSearch({'type': 'task', 'task_id': task.id }, updateTask)
            }

            $scope.discover = function () {

                $scope.discovery.pending = true;
                $scope.projectsTable.selectAll(false);

                JenkinsRequest.list({job_id: $scope.job.id, filter: $scope.discovery.pattern}, registerTask)
            };

            $scope.addProjects = function () {
                var data,
                    success,
                    error,
                    deferred = $q.defer(),
                    project_names = _.map($scope.projectsTable.getSelected(), function (item) {
                        return item.name;
                    });

                    data = {
                        'projects': project_names
                    };

                success = function (response) {
                    $scope.successMessages.push(translate('Added %x projects to job %y.')
                        .replace('%x', $scope.projectsTable.numSelected)
                        .replace('%y', $scope.job.name));
                    $scope.projectsTable.working = false;
                    $scope.projectsTable.rows = _.difference($scope.projectsTable.rows, $scope.projectsTable.getSelected())
                    $scope.projectsTable.selectAll(false);
                    deferred.resolve(response);
                };

                error = function (response) {
                    deferred.reject(response.data.errors);
                    angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving Adding Projects: ') + errorMessage);
                        });
                    $scope.projectsTable.working = false;
                };

                $scope.projectsTable.working = true;
                Job.addProjects({id: $scope.job.id}, data, success, error);
                return deferred.promise;
            };


        }
]);