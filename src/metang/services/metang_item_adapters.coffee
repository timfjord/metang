angular.module('metang').factory 'MetangItemAdapters', ->
  Adapters = {}

  class Base
    constructor: ->
      @nameAttr = 'name'

    getNameAttr: -> @nameAttr
    getName: ->
      name = @name
      name = @namespace + ':' + name if @namespace
      name
    getValue: -> @value
    setValue: (value) -> @value = value

    uniqId: ->
      @nameAttr + @namespace + @name

    template: ->
      "<meta #{@nameAttr}=\"{{item.getName()}}\" content=\"{{item.getValue()}}\">"

  class Adapters.Meta extends Base
    constructor: (name, value, namespace) ->
      super()
      @name = name
      @namespace = namespace
      @setValue value

  class Adapters.Property extends Adapters.Meta
    constructor: (name, value, namespace) ->
      super name, value, namespace
      @nameAttr = 'property'

  class Adapters.Title
    options:
      separator: ' | '

    constructor: (options) ->
      angular.extend @options, options || {}
      @title = ''

    setValue: (value) ->
      if angular.isObject value
        angular.extend @options, value
      else if angular.isString value
        @title = value

    getValue: ->
      parts = []
      parts.push @options.prefix if @options.prefix
      parts.push @title if @title
      parts.push @options.suffix if @options.suffix

      parts.join @options.separator

    uniqId: -> 'title'

    template: ->
      '<title ng-bind="item.getValue()"></title>'


  Adapters

