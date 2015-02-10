angular.module('Integration.jenkins-instances').controller('NewJenkinsInstanceController',
    ['$scope', 'translate', 'JenkinsInstance', 
    function ($scope, translate, JenkinsInstance) {

        $scope.successMessages = [];
        $scope.errorMessages = [];
        $scope.jenkinsInstance = new JenkinsInstance();

        var success = function (jenkinsInstance) {
            $scope.working = false;
            $scope.successMessages = [translate('New Jenkins Instance successfully creted.')];

            if ($scope.jenkinsTable) {
                $scope.jenkinsTable.rows.unshift(jenkinsInstance);
            }
            $scope.transitionBack();
        };

        var error = function (response) {
            $scope.working = false;
            angular.forEach(response.data.errors, function (errors, field) {
                try {
                    $scope.jenkinsInstanceForm[field].$setValidity('server', false);
                    $scope.jenkinsInstanceForm[field].$error.messages = errors;    
                } 
                catch (err) {
                    $scope.errorMessages.push(errors);
                }
                
            });
        };

        $scope.createJenkinsInstance = function (jenkinsInstance) {
            jenkinsInstance.$save(success, error);
        };



    }]
);