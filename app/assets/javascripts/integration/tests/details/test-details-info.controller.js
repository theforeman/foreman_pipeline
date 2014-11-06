angular.module('Integration.integration').controller('TestDetailsInfoController', 
    ['$scope', '$q', 'translate', 'Test',
    function ($scope, $q, translate, Test) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.panel = $scope.panel || {loading: false};

        $scope.test = $scope.test || Test.get({id: $scope.$stateParams.testId}, function () {
            $scope.panel.loading = false;
        });

        $scope.save = function (test) {
            var success,
                error,
                deferred = $q.defer();

            success = function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('Test updated.'))
            }

            error = function (response) {
                deferred.reject(response);
                angular.forEach(response.data.erorrs, function (errorMessage, key) {
                    if (angular.isString(key)) {
                        errorMessage = [key, errorMessage].join(' ');
                    }
                    $scope.errorMessages.push(translate('Error occured while saving the Test: ') + errorMessage);
                });
            }

            test.$update(success, error);
            return deferred.promise;
        };
    }]
);