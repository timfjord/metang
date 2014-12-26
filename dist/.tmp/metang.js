(function() {
  angular.module('metang.directives', []);

  angular.module('metang', ['metang.directives']);

  angular.module('metang.directives').directive('meta', function() {
    return {
      restrict: 'A'
    };
  });

  angular.module('metang.directives').directive('metaTags', function() {
    return {
      restrict: 'E'
    };
  });

}).call(this);
