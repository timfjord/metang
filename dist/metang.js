(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  angular.module('metang', []);

  angular.module('metang').directive('metang', function() {
    return {
      require: '^?metangHead',
      restrict: 'A',
      scope: {
        options: '@metang',
        property: '@',
        name: '@',
        content: '@'
      },
      controller: ["$scope", "$element", "metang", function($scope, $element, metang) {
        var tag;
        tag = $element[0].nodeName.toLowerCase();
        $scope.getItem = function() {
          var data, meta, method, name, namespace, parts, titleValue;
          if ($scope.item) {
            return $scope.item;
          }
          if (tag === 'title' || $scope.options === 'title') {
            titleValue = $element.text();
            if ($scope.options === 'prefix' || $scope.options === 'suffix') {
              titleValue = {};
              titleValue[$scope.options] = $element.text();
            }
            $scope.item = metang.title(titleValue);
          } else if (tag === 'meta') {
            data = {};
            method = '';
            namespace = '';
            name = $scope.property ? (method = 'property', $scope.property) : (method = 'meta', $scope.name);
            parts = name.split(':');
            if (parts[1]) {
              namespace = parts[0];
              name = parts[1];
            }
            data[name] = $scope.content;
            meta = metang[method](namespace, data);
            $scope.item = meta[0];
          } else {
            throw 'Not supported';
          }
          return $scope.item;
        };
        if (tag === 'title' || tag === 'meta') {
          $scope.$watch('item.getValue()', function(newVal, oldVal) {
            if (tag === 'meta') {
              $element.attr('content', newVal);
            }
            if (tag === 'title') {
              return $element.text(newVal);
            }
          });
        }
      }],
      link: function(scope, element, attributes, metangHeadCtrl) {
        if (metangHeadCtrl && metangHeadCtrl.exclude) {
          return metangHeadCtrl.exclude(scope.getItem().uniqId());
        }
      }
    };
  });

  angular.module('metang').directive('metangHead', ["$compile", function($compile) {
    return {
      restrict: 'A',
      scope: true,
      controller: ["$scope", "metang", function($scope, metang) {
        var excluded;
        excluded = [];
        this.exclude = function(item) {
          return excluded.push(item);
        };
        $scope.getItems = function() {
          return metang.getItems();
        };
        $scope.isRenderItem = function(item) {
          return excluded.indexOf(item.uniqId()) === -1;
        };
      }],
      link: function(scope, element, attributes) {
        var metaTags;
        metaTags = $compile('<meta metang-item="item" ng-repeat="item in getItems()" ng-if="isRenderItem(item)"/>')(scope);
        return element.append(metaTags);
      }
    };
  }]);

  angular.module('metang').directive('metangItem', ["$compile", function($compile) {
    return {
      restrict: 'A',
      scope: {
        item: '=metangItem'
      },
      link: function(scope, element, attributes) {
        var tag;
        tag = $compile(scope.item.template())(scope);
        return element.replaceWith(tag);
      }
    };
  }]);

  angular.module('metang').factory('MetangItemAdapters', function() {
    var Adapters, Base;
    Adapters = {};
    Base = (function() {
      function Base() {
        this.nameAttr = 'name';
      }

      Base.prototype.getNameAttr = function() {
        return this.nameAttr;
      };

      Base.prototype.getName = function() {
        var name;
        name = this.name;
        if (this.namespace) {
          name = this.namespace + ':' + name;
        }
        return name;
      };

      Base.prototype.getValue = function() {
        return this.value;
      };

      Base.prototype.setValue = function(value) {
        return this.value = value;
      };

      Base.prototype.uniqId = function() {
        return this.nameAttr + this.namespace + this.name;
      };

      Base.prototype.template = function() {
        return "<meta " + this.nameAttr + "=\"{{item.getName()}}\" content=\"{{item.getValue()}}\">";
      };

      return Base;

    })();
    Adapters.Meta = (function(_super) {
      __extends(Meta, _super);

      function Meta(name, value, namespace) {
        Meta.__super__.constructor.call(this);
        this.name = name;
        this.namespace = namespace;
        this.setValue(value);
      }

      return Meta;

    })(Base);
    Adapters.Property = (function(_super) {
      __extends(Property, _super);

      function Property(name, value, namespace) {
        Property.__super__.constructor.call(this, name, value, namespace);
        this.nameAttr = 'property';
      }

      return Property;

    })(Adapters.Meta);
    Adapters.Title = (function() {
      Title.prototype.options = {
        separator: ' | '
      };

      function Title(options) {
        angular.extend(this.options, options || {});
        this.title = '';
      }

      Title.prototype.setValue = function(value) {
        if (angular.isObject(value)) {
          return angular.extend(this.options, value);
        } else if (angular.isString(value)) {
          return this.title = value;
        }
      };

      Title.prototype.getValue = function() {
        var parts;
        parts = [];
        if (this.options.prefix) {
          parts.push(this.options.prefix);
        }
        if (this.title) {
          parts.push(this.title);
        }
        if (this.options.suffix) {
          parts.push(this.options.suffix);
        }
        return parts.join(this.options.separator);
      };

      Title.prototype.uniqId = function() {
        return 'title';
      };

      Title.prototype.template = function() {
        return '<title ng-bind="item.getValue()"></title>';
      };

      return Title;

    })();
    return Adapters;
  });

  angular.module('metang').provider('metang', function() {
    var defaults, isEmptyObject, items, _set;
    defaults = {
      title: {},
      meta: {},
      property: {}
    };
    isEmptyObject = function(obj) {
      var k, n;
      for (k in obj) {
        n = obj[k];
        if (obj.hasOwnProperty(k)) {
          return false;
        }
      }
      return true;
    };
    this.title = function(value) {
      return angular.extend(defaults.title, value);
    };
    _set = function(variable, namespace, data) {
      if (angular.isObject(namespace)) {
        data = namespace;
        namespace = '';
      }
      if (!defaults[variable][namespace]) {
        defaults[variable][namespace] = {};
      }
      return angular.extend(defaults[variable][namespace], data);
    };
    this.meta = function(v1, v2) {
      return _set('meta', v1, v2);
    };
    this.property = function(v1, v2) {
      return _set('property', v1, v2);
    };
    items = [];
    this.$get = ["$rootScope", "MetangItemAdapters", function($rootScope, MetangItemAdapters) {
      var api, data, findItem, namespace, set, _ref, _ref1;
      findItem = function(uniqId) {
        var item, _i, _len;
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          if (item.uniqId() === uniqId) {
            return item;
          }
        }
        return false;
      };
      set = function(adapter, namespace, data) {
        var item, name, newItem, result, value;
        if (angular.isObject(namespace)) {
          data = namespace;
          namespace = '';
        }
        result = [];
        for (name in data) {
          value = data[name];
          newItem = new MetangItemAdapters[adapter](name, value, namespace);
          item = findItem(newItem.uniqId());
          if (item) {
            item.setValue(newItem.getValue());
            result.push(item);
          } else {
            result.push(newItem);
            items.push(newItem);
          }
        }
        return result;
      };
      api = {
        getItems: function() {
          return items;
        }
      };
      api.title = function(value) {
        var title;
        title = findItem('title');
        if (!title) {
          title = new MetangItemAdapters.Title();
          items.push(title);
        }
        if (value) {
          title.setValue(value);
        }
        return title;
      };
      api.meta = function(v1, v2) {
        return set('Meta', v1, v2);
      };
      api.property = function(v1, v2) {
        return set('Property', v1, v2);
      };
      if (!isEmptyObject(defaults.title)) {
        api.title(defaults.title);
      }
      _ref = defaults.meta;
      for (namespace in _ref) {
        data = _ref[namespace];
        api.meta(namespace, data);
      }
      _ref1 = defaults.property;
      for (namespace in _ref1) {
        data = _ref1[namespace];
        api.property(namespace, data);
      }
      return api;
    }];
  });

}).call(this);
