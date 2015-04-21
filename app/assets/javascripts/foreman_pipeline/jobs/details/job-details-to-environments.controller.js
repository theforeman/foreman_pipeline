angular.module('ForemanPipeline.jobs').controller('JobDetailsToEnvironmentsController',
    ['$scope', '$q', 'Job', 'translate', 'CurrentOrganization',
        function ($scope, $q, Job, translate, CurrentOrganization) {

            $scope.successMessages = [];
            $scope.errorMessages = [];
            $scope.environments = [];

            $scope.job = $scope.job || Job.$get({id: $scope.$stateParams.jobId}, function () {
                $scope.panel.loading = false;
            });

            var params = {
                id: $scope.$stateParams.jobId,
                organization_id: CurrentOrganization,
            };

            $scope.toEnvironments = $scope.job.to_environments;

            $scope.loading = true;      

            $scope.paths = Job.availableEnvironments(params, function () {
                $scope.loading = false;
            });

            $scope.setToEnvironments = function () {
                console.log($scope.job)
                var success, 
                    error,
                    deferred = $q.defer();                    
                    data = {to_environment_ids: _.map($scope.toEnvironments, function (env) { return env.id })};

                    success = function (response) {
                        deferred.resolve(response);
                        $scope.successMessages.push(translate("New 'to environments' successfully set."))
                        $scope.working = false;
                        $scope.job.to_environments = $scope.toEnvironments;
                    };

                    error = function (response) {
                        deferred.reject(response);
                        angular.forEach(response.data.errors, function (errorMessage, key) {
                            if (angular.isString(key)) {
                                errorMessage = [key, errorMessage].join(' ');
                            }
                            $scope.errorMessages.push(translate('Error occured while saving the Job: ' + errorMessage));
                        });
                        $scope.working = false;
                    };

                    $scope.working = true;
                    Job.setToEnvironments({id: $scope.job.id}, data, success, error);
                    return deferred.promise;
            };
        }]

).directive('plnPathSelector',
    function () {
    return {
        restrict: 'AE',
        // templateUrl: 'jobs/views/pln-path-selector.html',
        // using templateUrl gives me deprecated XMLHttp request from jQuery, perhaps somehow preload and precompile would help?  
        template: '<div class="path-selector" ng-repeat="path in paths">'+
                      '<ul class="path-list">'+
                        '<li class="path-list-item" ng-repeat="item in path" ng-class="{ \'disabled-item\': item.disabled }">'+
                          '<label class="path-list-item-label" ng-disabled="item.disabled" ng-class="{ active: item.selected }" ng-mouseenter="hover" ng-mouseleave="hover = false">'+
                            '<input type="checkbox" ng-model="item.selected" ng-change="itemChanged(item)" ng-disabled="item.disabled"/>'+
                            '{{ item.name }}'+
                          '</label>'+
                        '</li>'+
                      '</ul>'+
                    '</div>',
        link: function (scope, element, attrs, ngModel) {
            var activeItemId;
            
            if (scope.paths.$promise) {
                scope.paths.$promise.then(function (paths) {
                    scope.paths = convertPathObjects(paths);
                    itemsLoad();
                });
            } else {
                scope.paths = convertPathObjects(scope.paths);
                itemsLoad();
            }

            function forEachInModel(callback){    
                angular.forEach(scope.toEnvironments, function (modelItem) {
                    callback(modelItem);
                });                
            }

            function forEachItem(callback) {
                angular.forEach(scope.paths, function (path) {
                    angular.forEach(path, function (item) {
                        callback(item);
                    });
                });
            }

            function unselectItem(item) {
                scope.toEnvironments = _.reject(scope.toEnvironments, function (obj) { return obj.id === item.id });
            }

            function selectItem(item) {
                scope.toEnvironments = _.union(scope.toEnvironments, [item]);   
            }

            scope.itemChanged = function (item) {
                if (item) {
                    if (item.selected) {
                        selectItem(item);
                    } else {
                        unselectItem(item);
                    }
                }
            }

            function itemsLoad(){
                var modelIds = _.pluck(scope.toEnvironments, "id"),
                    succIds = _.pluck(scope.job.environment.successors, "id");
                forEachItem(function (item) {
                    forEachInModel(function (modelItem) {
                        if (item.id === modelItem.id) {
                            item.flag = true;
                        }
                    });
                    if (item.selected && !item.flag) {
                        item.selected = false;                        
                        modelIds = _.reject(modelIds, function (id) { return id === item.id });
                    } else if (!item.selected && item.flag) {
                        item.selected = true;                        
                        modelIds = _.union(modelIds, [item.id]);
                    }
                    item.flag = false;
                    if (_.indexOf(succIds, item.id) < 0) {
                        item.disabled = true;
                    }           
                });                
                scope.toEnvironments = [];
                forEachItem(function (item) {
                    angular.forEach(modelIds , function (id) {
                        if (item.id === id ){
                            scope.toEnvironments.push(item);
                        }
                    });
                });
            }

            function convertPathObjects(paths) {              
                if (scope.pathAttribute) {
                    paths = _.pluck(paths, scope.pathAttribute);
                }                
                return paths;
            }

        }
    };
});