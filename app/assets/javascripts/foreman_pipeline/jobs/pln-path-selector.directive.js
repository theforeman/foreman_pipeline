angular.module('ForemanPipeline.jobs').directive('plnPathSelector',
    function () {
    return {
        restrict: 'AE',
        require: '?ngModel',
        scope: {
            paths: '=plnPathSelector',
            mode: '@',
            disabled: '=',
            disableTrigger: '=',
            pathAttribute: '@'
        },
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
            var activeItemId, activeItemIds = [];
            
            if (scope.paths.$promise) {
                scope.paths.$promise.then(function (paths) {
                    scope.paths = convertPathObjects(paths);
                    itemChanged(ngModel.$modelValue);
                });
            } else {
                scope.paths = convertPathObjects(scope.paths);
                scope.itemChanged(ngModel.$modelValue);
            }

            function forEachInModel(callback){
                angular.forEach(ngModel.$modelValue, function (modelItem) {
                    callback(modelItem);
                });
                console.log(ngModel.$modelValue);
            }

            function forEachItem(callback) {
                angular.forEach(scope.paths, function (path) {
                    angular.forEach(path, function (item) {
                        callback(item);
                    });
                });
            }            

            function selectById(id) {
                forEachItem(function (item) {
                    if (item.id === id) {
                        ngModel.$setViewValue(item);
                        item.selected = true;
                    }
                });
            }

            function unselectActive() {
                forEachItem(function (item) {
                    if (item.id === activeItemId) {
                        item.selected = false;
                    }
                });
            }

            function itemChanged(item) {
                forEachInModel();
                if (item) {
                    if (item.selected) {
                        selectById(item.id);
                        activeItemId = item.id;
                    } else {
                        ngModel.$setViewValue(undefined);
                    }
                }
            }

            function convertPathObjects(paths) {              
                if (scope.pathAttribute) {
                    paths = _.pluck(paths, scope.pathAttribute);
                }                
                return paths;
            }


            ngModel.$render = function () {
                if (ngModel.$modelValue) {
                    ngModel.$modelValue.selected = true;
                    itemChanged(ngModel.$modelValue);
                }
            };

            // scope.$watch('disableTrigger', function (disable) {
            //     forEachItem(function (item) {
            //         item.disabled = disable;
            //     });
            // });
        }
    };
});
