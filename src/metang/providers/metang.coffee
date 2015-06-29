angular.module('metang').provider 'metang', ->
  defaults =
    title: {}
    meta: {}
    property: {}

  isEmptyObject = (obj) ->
    for k,n of obj
      return false if obj.hasOwnProperty k
    true

  @title = (value) ->
    angular.extend defaults.title, value

  _set = (variable, namespace, data) ->
    if angular.isObject(namespace)
      data = namespace
      namespace = ''

    defaults[variable][namespace] = {} unless defaults[variable][namespace]
    angular.extend defaults[variable][namespace], data
  @meta = (v1, v2) -> _set 'meta', v1, v2
  @property = (v1, v2) -> _set 'property', v1, v2

  items = []
  @$get = ($rootScope, MetangItemAdapters) ->
    findItem = (uniqId) ->
      for item in items
        return item if item.uniqId() == uniqId
      false

    set = (adapter, namespace, data) ->
      if angular.isObject(namespace)
        data = namespace
        namespace = ''

      result = []
      for name, value of data
        newItem = new MetangItemAdapters[adapter] name, value, namespace
        item = findItem newItem.uniqId()
        if item
          item.setValue newItem.getValue()
          result.push item
        else
          result.push newItem
          items.push newItem
      result

    api = getItems: -> items

    api.title = (value) ->
      title = findItem 'title'
      unless title
        title = new MetangItemAdapters.Title()
        items.push title
      title.setValue value if value
      title

    api.meta = (v1, v2) -> set 'Meta', v1, v2

    api.property = (v1, v2) -> set 'Property', v1, v2

    api.title defaults.title unless isEmptyObject(defaults.title)
    api.meta namespace, data for namespace, data of defaults.meta
    api.property namespace, data for namespace, data of defaults.property

    api

  return
