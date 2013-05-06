// Generated by CoffeeScript 1.6.2
var $, Backbone, Collection, CollectionView, Model, View, equal, ok, _ref, _ref1, _ref2,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

_ref = Backbone = require('backbone'), Collection = _ref.Collection, Model = _ref.Model;

$ = Backbone.$ = require('jquery');

_ref1 = require('./backbone.viewx'), View = _ref1.View, CollectionView = _ref1.CollectionView;

_ref2 = require('assert'), equal = _ref2.equal, ok = _ref2.ok;

describe('backbone.viewx', function() {
  var $body;

  $body = $('body');
  beforeEach(function() {
    return $body.html('');
  });
  return describe('View', function() {
    describe('subview management', function() {
      var MyView, _ref3;

      MyView = (function(_super) {
        __extends(MyView, _super);

        function MyView() {
          _ref3 = MyView.__super__.constructor.apply(this, arguments);
          return _ref3;
        }

        MyView.prototype.initialize = function() {
          return this.a = this.view(new View);
        };

        return MyView;

      })(View);
      it('stores subviews in viewsByCid index', function() {
        var view;

        view = new MyView();
        return equal(view.viewsByCid[view.a.cid], view.a);
      });
      return it('removes subviews on view remove', function() {
        var view;

        view = new MyView();
        view.remove();
        return equal(view.viewsByCid[view.a.cid], void 0);
      });
    });
    describe('DOM insertion methods', function() {
      var MyView, _ref3;

      MyView = (function(_super) {
        __extends(MyView, _super);

        function MyView() {
          _ref3 = MyView.__super__.constructor.apply(this, arguments);
          return _ref3;
        }

        MyView.prototype.inDOM = false;

        MyView.prototype.onEnterDOM = function() {
          return this.inDOM = true;
        };

        return MyView;

      })(View);
      describe('appendTo()', function() {
        it('appends to a DOM element', function() {
          var view;

          $body.append($('<a></a>'));
          view = (new MyView).render().appendTo($body);
          equal($body.html(), '<a></a><div></div>');
          return ok(view.inDOM);
        });
        return it('appends to a view DOM element', function() {
          var parent, view;

          parent = new MyView;
          parent.$el.append($('<a></a>'));
          view = (new MyView).render().appendTo(parent);
          equal(parent.$el.html(), '<a></a><div></div>');
          return ok(!view.inDOM);
        });
      });
      describe('prependTo()', function() {
        it('prepends to a DOM element', function() {
          var view;

          $body.append($('<a></a>'));
          view = (new MyView).render().prependTo($body);
          equal($body.html(), '<div></div><a></a>');
          return ok(view.inDOM);
        });
        return it('prepends to a view DOM element', function() {
          var parent, view;

          parent = new MyView;
          parent.$el.append($('<a></a>'));
          view = (new MyView).render().prependTo(parent);
          equal(parent.$el.html(), '<div></div><a></a>');
          return ok(!view.inDOM);
        });
      });
      describe('appendAfter()', function() {
        it('appends after a DOM element', function() {
          var $point, view;

          $point = $('<a></a>');
          $body.append($point);
          view = (new MyView).render().appendAfter($point);
          equal($body.html(), '<a></a><div></div>');
          return ok(view.inDOM);
        });
        return it('appends after a view DOM element', function() {
          var point, view;

          point = (new MyView({
            tagName: 'a'
          })).render();
          $body.append(point.$el);
          view = (new MyView).render().appendAfter(point);
          equal($body.html(), '<a></a><div></div>');
          return ok(view.inDOM);
        });
      });
      describe('prependAfter()', function() {
        it('prepends after a DOM element', function() {
          var $point, view;

          $point = $('<a></a>');
          $body.append($point);
          view = (new MyView).render().appendBefore($point);
          equal($body.html(), '<div></div><a></a>');
          return ok(view.inDOM);
        });
        return it('prepends after a view DOM element', function() {
          var point, view;

          point = (new MyView({
            tagName: 'a'
          })).render();
          $body.append(point.$el);
          view = (new MyView).render().appendBefore(point);
          equal($body.html(), '<div></div><a></a>');
          return ok(view.inDOM);
        });
      });
      describe('append()', function() {
        it('appends a DOM element', function() {
          var view;

          view = (new MyView).render();
          view.$el.append($('<div></div>'));
          view.append($('<a></a>'));
          equal(view.$el.html(), '<div></div><a></a>');
          return ok(!view.inDOM);
        });
        return it('appends a view DOM element', function() {
          var view;

          view = (new MyView).render();
          view.$el.append($('<div></div>'));
          view.append((new MyView({
            tagName: 'a'
          })).render());
          equal(view.$el.html(), '<div></div><a></a>');
          return ok(!view.inDOM);
        });
      });
      describe('prepend()', function() {
        it('prepends a DOM element', function() {
          var view;

          view = (new MyView).render();
          view.$el.append($('<div></div>'));
          view.prepend($('<a></a>'));
          equal(view.$el.html(), '<a></a><div></div>');
          return ok(!view.inDOM);
        });
        return it('prepends a view DOM element', function() {
          var view;

          view = (new MyView).render();
          view.$el.append($('<div></div>'));
          view.prepend((new MyView({
            tagName: 'a'
          })).render());
          equal(view.$el.html(), '<a></a><div></div>');
          return ok(!view.inDOM);
        });
      });
      describe('after()', function() {
        it('appends a DOM element after', function() {
          var view;

          view = (new MyView).render();
          $body.append(view.$el);
          view.after($('<a></a>'));
          return equal($body.html(), '<div></div><a></a>');
        });
        return it('appends a view DOM element after', function() {
          var view;

          view = (new MyView).render();
          $body.append(view.$el);
          view.after((new MyView({
            tagName: 'a'
          })).render());
          return equal($body.html(), '<div></div><a></a>');
        });
      });
      return describe('before()', function() {
        it('appends a DOM element before', function() {
          var view;

          view = (new MyView).render();
          $body.append(view.$el);
          view.before($('<a></a>'));
          return equal($body.html(), '<a></a><div></div>');
        });
        return it('appends a view DOM element before', function() {
          var view;

          view = (new MyView).render();
          $body.append(view.$el);
          view.before((new MyView({
            tagName: 'a'
          })).render());
          return equal($body.html(), '<a></a><div></div>');
        });
      });
    });
    return describe('CollectionView', function() {
      var MyView, collection, makeCollection, _ref3;

      makeCollection = function() {
        var c;

        c = new Collection([], {
          comparator: function(model) {
            return model.get('ord');
          }
        });
        c.add(new Model({
          name: 'a',
          ord: 1
        }), {
          sort: false
        });
        c.add(new Model({
          name: 'b',
          ord: 2
        }), {
          sort: false
        });
        return c.add(new Model({
          name: 'c',
          ord: 0
        }), {
          sort: false
        });
      };
      collection = makeCollection();
      MyView = (function(_super) {
        var _ref4;

        __extends(MyView, _super);

        function MyView() {
          _ref3 = MyView.__super__.constructor.apply(this, arguments);
          return _ref3;
        }

        MyView.prototype.itemView = (function(_super1) {
          __extends(_Class, _super1);

          function _Class() {
            _ref4 = _Class.__super__.constructor.apply(this, arguments);
            return _ref4;
          }

          _Class.prototype.render = function() {
            return this.$el.html(this.model.get('name'));
          };

          return _Class;

        })(View);

        return MyView;

      })(CollectionView);
      it('should render a collection', function() {
        var v;

        v = new MyView({
          collection: collection
        }).render();
        return equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
      });
      it('should re-render collection on reset', function() {
        var v;

        collection = makeCollection();
        v = new MyView({
          collection: collection
        }).render();
        equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
        collection.reset([
          new Model({
            name: 'x'
          })
        ]);
        return equal(v.$el.html(), '<div>x</div>');
      });
      it('should re-order item views on sort', function() {
        var v;

        collection = makeCollection();
        v = new MyView({
          collection: collection
        }).render();
        equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
        collection.sort();
        return equal(v.$el.html(), '<div>c</div><div>a</div><div>b</div>');
      });
      describe('add to collection', function() {
        it('should react on add new item to the end of the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.add(new Model({
            name: 'd'
          }), {
            sort: false
          });
          return equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div><div>d</div>');
        });
        it('should react on add new item to the start of the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.add(new Model({
            name: 'd'
          }), {
            at: 0
          });
          return equal(v.$el.html(), '<div>d</div><div>a</div><div>b</div><div>c</div>');
        });
        return it('should react on add new item by index to the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.add(new Model({
            name: 'd'
          }), {
            at: 2
          });
          return equal(v.$el.html(), '<div>a</div><div>b</div><div>d</div><div>c</div>');
        });
      });
      return describe('remove from collection', function() {
        it('should react on remove item from the start of the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.remove(collection.at(0));
          return equal(v.$el.html(), '<div>b</div><div>c</div>');
        });
        it('should react on remove item from the end of the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.remove(collection.last());
          return equal(v.$el.html(), '<div>a</div><div>b</div>');
        });
        return it('should react on remove item from the middle of the collection', function() {
          var v;

          collection = makeCollection();
          v = new MyView({
            collection: collection
          }).render();
          equal(v.$el.html(), '<div>a</div><div>b</div><div>c</div>');
          collection.remove(collection.at(1));
          return equal(v.$el.html(), '<div>a</div><div>c</div>');
        });
      });
    });
  });
});