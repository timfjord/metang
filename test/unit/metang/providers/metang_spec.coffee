describe 'metang', ->
  beforeEach module 'metang', (metangProvider) ->
    metangProvider.title
      separator: ' - '
      prefix: 'My Site Prefix'
      suffix: 'My Site Suffix'
    metangProvider.meta description: 'desc', author: 'Author'
    metangProvider.meta 'twitter', card: 'summary'
    metangProvider.property 'og', title: 'My Title'
    return

  metang = MetangItemAdapters = null

  beforeEach inject (_metang_, _MetangItemAdapters_) ->
    metang = _metang_
    MetangItemAdapters = _MetangItemAdapters_

  it 'should allow to get all meta items', ->
    values = metang.getItems().map (i) -> i.getValue()

    expect(values.length).toEqual 5
    expect(values).toContain 'desc'
    expect(values).toContain 'Author'
    expect(values).toContain 'summary'
    expect(values).toContain 'My Title'
    expect(values).toContain 'My Site Prefix - My Site Suffix'

  it 'should get title', ->
    title = metang.title()

    expect(title instanceof MetangItemAdapters.Title).toBeTruthy()
    expect(title.options).toEqual jasmine.objectContaining
      separator: ' - '
      prefix: 'My Site Prefix'
      suffix: 'My Site Suffix'

  it 'should set title', ->
    title = metang.title 'My Title'

    expect(metang.getItems().length).toEqual 5
    expect(title.getValue()).toEqual 'My Site Prefix - My Title - My Site Suffix'

  it 'should update meta tags', ->
    metang.title
      separator: ' ~ '
      prefix: 'My Site Prefix1'
      suffix: 'My Site Suffix1'
    metang.meta description: 'desc1', author: 'Author1'
    metang.meta 'twitter', card: 'summary1'
    metang.property 'og', title: 'My Title1'

    values = metang.getItems().map (i) -> i.getValue()

    expect(values.length).toEqual 5
    expect(values).toContain 'desc1'
    expect(values).toContain 'Author1'
    expect(values).toContain 'summary1'
    expect(values).toContain 'My Title1'
    expect(values).toContain 'My Site Prefix1 ~ My Site Suffix1'
