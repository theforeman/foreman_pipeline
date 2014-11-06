angular.module('Integration.integration').controller('JobsDetailsNewContentViewController',
    ['$scope', 'translate', 'ContentView', 'CurrentOrganization', 
        function ($scope, translate, ContentView, CurrentOrganization) {

            $scope.contentView = new ContentView();

            $scope.save = function (contentView) {
                
                contentView.$save(success, error);
            };

            var success = function (response) {
                $scope.working = false;
                $scope.transitionTo('jobs.details.content-views.new.repos', {contentViewId: response.id})
            }

            var error = function (response) {
                
            }
        }]
);