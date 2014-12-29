angular.module('metang').directive 'metang', ->
  require: '^?metangHead'
  restrict: 'A'
  scope:
    options: '@metang'
    property: '@'
    name: '@'
    content: '@'
  controller: ($scope, $element, metang) ->
    tag = $element[0].nodeName.toLowerCase()

    $scope.getItem = ->
      return $scope.item if $scope.item

      if tag == 'title' || $scope.options == 'title'
        titleValue = $element.text()
        if $scope.options == 'prefix' || $scope.options == 'suffix'
          titleValue = {}
          titleValue[$scope.options] = $element.text()
        $scope.item = metang.title titleValue
      else if tag == 'meta'
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
        $scope.item = meta[0]
      else
        throw 'Not supported'

      $scope.item

    if tag == 'title' || tag == 'meta'
      $scope.$watch 'item.getValue()', (newVal, oldVal) ->
        $element.attr 'content', newVal if tag == 'meta'
        $element.text newVal if tag == 'title'

    return

  link: (scope, element, attributes, metangHeadCtrl) ->
    metangHeadCtrl.exclude scope.getItem().uniqId() if metangHeadCtrl && metangHeadCtrl.exclude
