# [metang](https://github.com/timsly/metang/)

![](http://www.poke-amph.com/heartgoldsoulsilver/sprites/375.png)

**metang** it is not just robotic Pokémon it's also AngularJS library to manage meta tags.
Currently it supports only rendering meta tags with name or property atrributes and title.

## Installation
1. Install **metang** via bower: `bower install metang`
2. Include files in the app: `dist/metang.js`(`dist/metang.min.js`)
3. Include module: `metang`

##Usage

####Configuration

```js
angular.module('YourModule').config(function(metangProvider) {
  metangProvider.title({
    separator: ' - ',
    prefix: 'My Site Prefix',
    suffix: 'My Site Suffix'
  });
  metangProvider.meta({description: 'desc', author: 'Author'});
  metangProvider.meta('twitter', {card: 'summary'});
  metangProvider.property('og', {title: 'My Title'});
});
```

####Provider
```js
angular.module('YourModule').controller('DetailsCtrl', function($scope, metang) {
   metang.title('Page title');
   metang.property('og', {description: 'Description'});
   metang.meta({description: 'Details description'});
});
```

Available methods:

* **metang.title**
  * `metang.title('My title')` - update title
  * `metang.title({separator: ' ~ ', prefix: 'My Site Prefix', suffix: 'My Site Suffix'})` - update title options
* **metang.meta**
  * `metang.meta({description: 'desc', author: 'Author'})` - update meta tags that use name attribute
  * `metang.meta('twitter', {card: 'summary'})` - update meta tags that use name attribute with namespace
* **metang.property**
  * `metang.property({title: 'My Title'})` - update meta tags that use property attribute
  * `metang.property('og', {description: 'Description'})` - update meta tags that use property attribute with namespace

All this methods available during config phase, with the only difference that `metang.title` accepts only object argument

####Template
```html
<head metang-head>
</head>
```

**metang** will automatically append all available meta tags(including title).

Title output wil be [Title Prefix][Title Separator][Title][Title Separator][Title Suffix]

In case you want to render title or other meta tags explicitly. You need to let **metang** knows about such tags and it will
update it dymanicaly and also exlude it from list that renders automatically
```html
<head metang-head>
  <title metang="prefix">My Site</title>
  <meta name="description" content="Desc of my website" metang>
</head>
```

## TODO

- [ ] Test covarage
- [ ] Add support for charset and http-equiv meta tags
- [ ] Add other tags like link

## Contributing

1. Fork it
2. Install all libraries (`npm install`)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Build project (`gulp build`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## License

Licensed under MIT.
