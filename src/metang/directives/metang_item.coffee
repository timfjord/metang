angular.module('metang').directive 'metangItem', ($compile) ->
  restrict: 'A'
  scope:
    item: '=metangItem'
  link: (scope, element, attributes) ->
    tag = $compile(scope.item.template())(scope)
    element.replaceWith tag
