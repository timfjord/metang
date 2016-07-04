describe 'MetangItemAdapters', ->
  beforeEach module('metang')

  MetangItemAdapters = null

  beforeEach inject (_MetangItemAdapters_) ->
    MetangItemAdapters = _MetangItemAdapters_

  describe 'Meta', ->
    beforeEach ->
      @meta = new MetangItemAdapters.Meta 'card', 'Card', 'twitter'

    it 'should calculate name', ->
      expect(@meta.getName()).toEqual 'twitter:card'

    it 'should get value', ->
      expect(@meta.getValue()).toEqual 'Card'

    it 'should calculate uniqId', ->
      expect(@meta.uniqId()).toEqual 'nametwittercard'

    it 'should calculate template', ->
      expect(@meta.template()).toEqual '<meta name="{{item.getName()}}" content="{{item.getValue()}}">'

  describe 'Property', ->
    beforeEach ->
      @property = new MetangItemAdapters.Property 'title', 'Title', 'og'

    it 'should calculate name', ->
      expect(@property.getName()).toEqual 'og:title'

    it 'should get value', ->
      expect(@property.getValue()).toEqual 'Title'

    it 'should calculate uniqId', ->
      expect(@property.uniqId()).toEqual 'propertyogtitle'

    it 'should calculate template', ->
      expect(@property.template()).toEqual '<meta property="{{item.getName()}}" content="{{item.getValue()}}">'

  describe 'Title', ->
    beforeEach ->
      @title = new MetangItemAdapters.Title()

    it 'should calculate uniqId', ->
      expect(@title.uniqId()).toEqual 'title'

    it 'should calculate template', ->
      expect(@title.template()).toEqual '<title ng-bind="item.getValue()"></title>'

    it 'should generate value base on options', ->
      title = new MetangItemAdapters.Title prefix: 'Prefix', suffix: 'Suffix', separator: ' - '
      expect(title.getValue()).toEqual 'Prefix - Suffix'

    it 'should allow to set title', ->
      @title.setValue 'Title'
      expect(@title.getValue()).toEqual 'Title'

    it 'should allow to title options', ->
      @title.setValue prefix: 'Prefix', suffix: 'Suffix', separator: ' - '
      expect(@title.getValue()).toEqual 'Prefix - Suffix'
