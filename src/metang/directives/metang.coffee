angular.module('metang').directive 'metang', ->
  require: '^?metangHead'
  restrict: 'A'
  scope:
    property: '@'
    name: '@'
    content: '@'
  controller: ($scope, $element, metang) ->
    $scope.getMeta = ->
      return @meta if @meta

      data = {}
      method = ''
      namespace = ''

      name = if $scope.property
        method = 'property'
        $scope.property
      else
        method = 'meta'
        $scope.name

      parts = name.split ':'
      if parts[1]
        namespace = parts[0]
        name = parts[1]

      data[name] = $scope.content
      meta = metang[method] namespace, data
      @meta = meta[0]

    $scope.$watch 'meta.getValue()', (newVal, oldVal) ->
      $element.attr 'content', newVal

    return

  link: (scope, element, attributes, metangHeadCtrl) ->
    metangHeadCtrl.exclude scope.getMeta().uniqId() if metangHeadCtrl && metangHeadCtrl.exclude
