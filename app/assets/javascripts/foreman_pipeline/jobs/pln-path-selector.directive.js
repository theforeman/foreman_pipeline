// angular.module('ForemanPipeline.jobs').directive('plnPathSelector',
//     function () {
//     return {
//         restrict: 'AE',
//         require: '?ngModel',
//         scope: {
//             paths: '=plnPathSelector',
//             mode: '@',
//             disabled: '=',
//             disableTrigger: '=',
//             pathAttribute: '@'
//         },
//         // templateUrl: 'jobs/views/pln-path-selector.html',
//         // using templateUrl gives me deprecated XMLHttp request from jQuery, perhaps somehow preload and precompile would help?  
//         template: '<div class="path-selector" ng-repeat="path in paths">'+
//                       '<ul class="path-list">'+
//                         '<li class="path-list-item" ng-repeat="item in path" ng-class="{ \'disabled-item\': item.disabled }">'+
//                           '<label class="path-list-item-label" ng-disabled="item.disabled" ng-class="{ active: item.selected }" ng-mouseenter="hover" ng-mouseleave="hover = false">'+
//                             '<input type="checkbox" ng-model="item.selected" ng-change="itemChanged(item)" ng-disabled="item.disabled"/>'+
//                             '{{ item.name }}'+
//                           '</label>'+
//                         '</li>'+
//                       '</ul>'+
//                     '</div>',
//         link: function (scope, element, attrs, ngModel) {
//             var activeItemId;
            
//             if (scope.paths.$promise) {
//                 scope.paths.$promise.then(function (paths) {
//                     scope.paths = convertPathObjects(paths);
//                     itemsLoad();
//                     // itemChanged(ngModel.$modelValue);
//                 });
//             } else {
//                 scope.paths = convertPathObjects(scope.paths);
//                 itemsLoad();
//                 // scope.itemChanged(ngModel.$modelValue);
//             }

//             function forEachInModel(callback){    
//                 angular.forEach(ngModel.$modelValue, function (modelItem) {
//                     callback(modelItem);
//                 });                
//             }

//             function forEachItem(callback) {
//                 angular.forEach(scope.paths, function (path) {
//                     angular.forEach(path, function (item) {
//                         callback(item);
//                     });
//                 });
//             }            

//             function selectById(id) {
//                 forEachItem(function (item) {
//                     if (item.id === id) {
//                         ngModel.$setViewValue(ngModel.$modelValue);
//                         item.selected = true;
//                     }
//                 });
//             }

//             function unselectItem(item) {
//                 debugger;
//                 ngModel.$modelValue = _.reject(ngModel.$modelValue, function (obj) { return obj.id === item.id });
//                 ngModel.$setViewValue(ngModel.$modelValue);
//                 console.log(scope.paths);
//             }

//             function selectItem(item) {
//                 // debugger;
//                 ngModel.$modelValue = _.union(ngModel.$modelValue, [item]);
//                 ngModel.$setViewValue(ngModel.$modelValue);
//                 console.log(scope.paths)
//                 // selectById(item.id)
//             }

//             // function unselectActive() {
//             //     forEachItem(function (item) {
//             //         if (item.id === activeItemId) {
//             //             item.selected = false;
//             //         }
//             //     });
//             // }


//             scope.itemChanged = function (item) {
//                 console.log("initial model values")
//                 console.log(ngModel.$modelValue);
//                 console.log(ngModel.$viewValue);
//                 debugger;
//                 if (item) {
//                     if (item.selected) {
//                         // item.selected = false;
//                         selectItem(item);
//                     } else {
//                         // item.selected = true;
//                         unselectItem(item);
//                         // ngModel.$setViewValue(undefined);
//                     }
//                 }
//                 console.log("model values after change")
//                 console.log(ngModel.$modelValue);
//                 console.log(ngModel.$viewValue);
//             }

//             function itemsLoad(){
//                 var modelIds = _.map(ngModel.$modelValue, function (obj) { return obj.id });
//                 forEachItem(function (item) {
//                     forEachInModel(function (modelItem) {
//                         if (item.id === modelItem.id) {
//                             item.flag = true;
//                         }
//                     });
//                     if (item.selected && !item.flag) {
//                         item.selected = false;                        
//                         modelIds = _.reject(modelIds, function (id) { return id === item.id });
//                     } else if (!item.selected && item.flag) {
//                         item.selected = true;                        
//                         modelIds = _.union(modelIds, [item.id]);
//                     }
//                     item.flag = false;
//                 });                
//                 ngModel.$modelValue = [];
//                 forEachItem(function (item) {
//                     angular.forEach(modelIds , function (id) {
//                         if (item.id === id ){
//                             ngModel.$modelValue.push(item);
//                         }
//                     });
//                 });
//             }

//             function convertPathObjects(paths) {              
//                 if (scope.pathAttribute) {
//                     paths = _.pluck(paths, scope.pathAttribute);
//                 }                
//                 return paths;
//             }


//             // ngModel.$render = function () {
//             //     console.log("render");

//             //     // if (ngModel.$modelValue) {
//             //         // ngModel.$modelValue.selected = true;
//             //         // itemChanged(ngModel.$modelValue);
//             //     // }
//             // };

//             // scope.$watch('disableTrigger', function (disable) {
//             //     forEachItem(function (item) {
//             //         item.disabled = disable;
//             //     });
//             // });
//         }
//     };
// });
