angular.module('metang').directive 'metangTitle', ->
  require: '^?metangHead'
  restrict: 'A'
  scope:
    part: '@metangTitle'
  controller: ($scope, $element, metang) ->
    titleValue = $element.text()
    if $scope.part == 'prefix' || $scope.part == 'suffix'
      titleValue = {}
      titleValue[$scope.part] = $element.text()
    $scope.title = metang.title titleValue

    $scope.$watch 'title.getValue()', (newVal, oldVal) ->
      $element.text newVal

    return

  link: (scope, element, attributes, metangHeadCtrl) ->
    metangHeadCtrl.exclude 'title' if metangHeadCtrl && metangHeadCtrl.exclude
