describe 'metangHead', ->
  beforeEach module 'metang', (metangProvider) ->
    metangProvider.title
      separator: ' - '
      prefix: 'My Site Prefix'
      suffix: 'My Site Suffix'
    metangProvider.meta description: 'desc', author: 'Author'
    metangProvider.meta 'twitter', card: 'summary'
    metangProvider.property 'og', title: 'My Title'
    return

  $rootScope = $compile = metang = null

  beforeEach inject (_$rootScope_, _$compile_, _metang_) ->
    $rootScope = _$rootScope_
    $compile = _$compile_
    metang = _metang_

  it 'should render all metang items', ->
    element = $compile('<div metang-head></div>')($rootScope)
    $rootScope.$digest()

    content = element.html()

    expect(content).toMatch /\<title.*\>My Site Prefix - My Site Suffix\<\/title\>/
    expect(content).toMatch /\<meta.*name="description".*content="desc".*>/
    expect(content).toMatch /\<meta.*name="author".*content="Author".*>/
    expect(content).toMatch /\<meta.*name="twitter:card".*content="summary".*>/
    expect(content).toMatch /\<meta.*property="og:title".*content="My Title".*>/

  it 'should allow to update title parts directly from html', ->
    element = $compile('<div metang-head><title metang="prefix">My New Site Prefix</title></div>')($rootScope)
    $rootScope.$digest()

    expect(element.html()).toMatch /\<title.*\>My New Site Prefix - My Site Suffix\<\/title\>/
    expect(metang.title().options.prefix).toEqual 'My New Site Prefix'

  it 'should allow to update other meta tags directly from html', ->
    element = $compile('<div metang-head><meta name="description" content="Desc of my website" metang></div>')($rootScope)
    $rootScope.$digest()

    expect(element.html()).toMatch /\<meta.*name="description".*content="Desc of my website".*>/
