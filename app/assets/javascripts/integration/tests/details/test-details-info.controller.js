angular.module('Integration.tests').controller('TestDetailsInfoController', 
    ['$scope', '$q', 'translate', 'Test',
    function ($scope, $q, translate, Test) {

        $scope.successMessages = [];
        $scope.errorMessages = [];

        $scope.panel = $scope.panel || {loading: false};

        $scope.test = $scope.test || Test.get({id: $scope.$stateParams.testId}, function () {
            $scope.panel.loading = false;
        });
        $scope.uploading = false;

        $scope.save = function (test) {
            var success,
                error,
                deferred = $q.defer();

            success = function (response) {
                deferred.resolve(response);
                $scope.successMessages.push(translate('Test updated.'));
                $scope.uploading = false;
            }

            error = function (response) {
                deferred.reject(response);
                angular.forEach(response.data.erorrs, function (errorMessage, key) {
                    if (angular.isString(key)) {
                        errorMessage = [key, errorMessage].join(' ');
                    }
                    $scope.errorMessages.push(translate('Error occured while saving the Test: ') + errorMessage);
                });
                $scope.uploading = false;
            }

            test.$update(success, error);
            return deferred.promise;
        };

        $scope.add = function () {
            $scope.uploading = true;
            var file = document.getElementById('file').files[0],
                reader = new FileReader();
            reader.onload = function (e) {
                var data = reader.result;
                $scope.test.content = data;
                $scope.save($scope.test);
            };
            reader.readAsText(file);            
        };

    }]
);