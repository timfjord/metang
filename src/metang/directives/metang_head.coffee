angular.module('metang').directive 'metangHead', ($compile) ->
  restrict: 'A'
  scope: true
  controller: ($scope, metang) ->
    excluded = []

    @exclude = (item) -> excluded.push item

    $scope.getItems = -> metang.getItems()

    $scope.isRenderItem = (item) -> excluded.indexOf(item.uniqId()) == -1
  link: (scope, element, attributes) ->
    metaTags = $compile('<meta metang-item="item" ng-repeat="item in getItems()" ng-if="isRenderItem(item)"/>')(scope)
    element.append metaTags
