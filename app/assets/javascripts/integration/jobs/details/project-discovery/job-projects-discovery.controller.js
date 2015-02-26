angular.module('Integration.jobs').controller('JobProjectsDiscoveryController',
 ['$scope', '$q', 'CurrentOrganization', 'Job', 'Task', 'JenkinsProject',
    function ($scope, $q, CurrentOrganization, Job, Task, JenkinsProject) {

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
            console.log(project_names)
            projects = _.map(project_names, function (item) {
                return {'name': item}
            });
            console.log(projects)

            return _.sortBy(projects, function (item) {
                return item.name;
            });
        }

        registerTask = function (task) {
            $scope.taskSearchId = Task.registerSearch({'type': 'task', 'task_id': task.id }, updateTask)
        }

        $scope.discover = function () {

            $scope.discovery.pending = true;
            $scope.projectsTable.selectAll(false);

            JenkinsProject.list({job_id: $scope.job.id, filter: $scope.discovery.pattern}, registerTask)
        };


}]);