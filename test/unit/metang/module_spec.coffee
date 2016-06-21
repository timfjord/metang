describe 'Module load', ->
  beforeEach ->
    @module = angular.module 'metang'

  it 'should load dependencies', ->
    expect(@module).toBeDefined()
