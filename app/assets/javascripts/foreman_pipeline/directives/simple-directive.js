angular.module('ForemanPipeline.directives').directive('simple', 
    function () {
        return {
            restrict: 'AE',
            // replace: true,
            template: '<div>Do you see me?</div>'
        }
    }
)