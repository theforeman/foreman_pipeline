angular.module('Integration.jobs').controller('JobProjectsParametersController', 
    ['$scope', '$state', '$q', 'translate', 'Job', 'Task', 'JenkinsProject', 'JenkinsRequest',
        function ($scope, $state, $q, translate, Job, Task, JenkinsProject, JenkinsRequest) {

            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.projectParamsList = [];
            console.log($scope.job)
            var getParameters, registerTask, updateTask, setDetails;

            getParameters = function () {
                $scope.pending = true;
                JenkinsRequest.getBuildParams({project_name: $scope.jenkinsProject.name, job_id: $scope.job.id}, registerTask);
            };

            registerTask = function (task) {
                $scope.taskSearchId = Task.registerSearch({'type': 'task', 'task_id': task.id}, updateTask)
            };

            updateTask = function (task) {
                setDetails(task);
                if (!task.pending) {
                    Task.unregisterSearch($scope.taskSearchId);
                }
            };

            setDetails = function (task) {
                $scope.pending = task.pending;
                if (!task.pending) {
                    console.log(task);
                }
            };

            $scope.jenkinsProject = JenkinsProject.get({
                'id': $scope.$stateParams.projectId
            }, getParameters);
            
    }
]);