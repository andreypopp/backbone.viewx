// Generated by CoffeeScript 1.6.2
var $, View, contains, extend, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

extend = require('underscore').extend;

_ref = require('backbone'), View = _ref.View, $ = _ref.$;

contains = function(doc, el) {
  return (doc.contains || $.contains)(doc, el);
};

exports.DOMInsertionMethods = {
  prependTo: function(el) {
    $(el.el || el).prepend(this.el);
    if (contains(this.el.ownerDocument.body, this.el)) {
      this.callOnEnterDOM();
    }
    return this;
  },
  appendTo: function(el) {
    $(el.el || el).append(this.el);
    if (contains(this.el.ownerDocument.body, this.el)) {
      this.callOnEnterDOM();
    }
    return this;
  },
  appendAfter: function(el) {
    $(el.el || el).after(this.el);
    if (contains(this.el.ownerDocument.body, this.el)) {
      this.callOnEnterDOM();
    }
    return this;
  },
  appendBefore: function(el) {
    $(el.el || el).before(this.el);
    if (contains(this.el.ownerDocument.body, this.el)) {
      this.callOnEnterDOM();
    }
    return this;
  },
  prepend: function(el) {
    if (el.el != null) {
      el.prependTo(this);
    } else {
      this.$el.prepend(el);
    }
    return this;
  },
  append: function(el) {
    if (el.el != null) {
      el.appendTo(this);
    } else {
      this.$el.append(el);
    }
    return this;
  },
  after: function(el) {
    if (el.el != null) {
      el.appendAfter(this);
    } else {
      this.$el.after(el);
    }
    return this;
  },
  before: function(el) {
    if (el.el != null) {
      el.appendBefore(this);
    } else {
      this.$el.before(el);
    }
    return this;
  },
  callOnEnterDOM: function() {
    var view, _, _ref1, _results;

    if (typeof this.onEnterDOM === "function") {
      this.onEnterDOM();
    }
    if (this.viewsByCid != null) {
      _ref1 = this.viewsByCid;
      _results = [];
      for (_ in _ref1) {
        view = _ref1[_];
        _results.push(typeof view.callOnEnterDOM === "function" ? view.callOnEnterDOM() : void 0);
      }
      return _results;
    }
  }
};

exports.View = (function(_super) {
  __extends(View, _super);

  extend(View.prototype, exports.DOMInsertionMethods);

  function View() {
    this.viewsByCid = {};
    View.__super__.constructor.apply(this, arguments);
  }

  View.prototype.view = function(view) {
    this.viewsByCid[view.cid] = view;
    return view;
  };

  View.prototype.removeView = function(view) {
    this.viewsByCid[view.cid] = void 0;
    view.remove();
    return this;
  };

  View.prototype.removeViews = function() {
    var view, _, _ref1;

    _ref1 = this.viewsByCid;
    for (_ in _ref1) {
      view = _ref1[_];
      this.removeView(view);
    }
    return this;
  };

  View.prototype.remove = function() {
    View.__super__.remove.apply(this, arguments);
    this.removeViews();
    return this;
  };

  return View;

})(View);

exports.CollectionView = (function(_super) {
  __extends(CollectionView, _super);

  CollectionView.prototype.itemView = void 0;

  CollectionView.prototype.makeItemView = void 0;

  function CollectionView() {
    CollectionView.__super__.constructor.apply(this, arguments);
    this.views = [];
    this.listenTo(this.collection, {
      reset: this.onReset,
      sort: this.onSort,
      add: this.onAdd,
      remove: this.onRemove
    });
  }

  CollectionView.prototype.removeView = function(view) {
    this.viewsByCid[view.cid] = void 0;
    this.views.splice(this.views.indexOf(view), 1);
    view.remove();
    return this;
  };

  CollectionView.prototype.render = function(template) {
    this.setupItemView(template);
    this.onReset();
    return this;
  };

  CollectionView.prototype.setupItemView = function(maybeTemplate) {
    if (this.options.itemView != null) {
      this.itemView = this.options.itemView;
    }
    return this.makeItemView = (function() {
      var _this = this;

      if (this.makeItemView != null) {
        return this.makeItemView;
      } else if (this.itemView != null) {
        return function(model, index) {
          var view;

          view = new _this.itemView({
            model: model
          });
          view = _this.view(view, {
            at: index
          });
          if (index != null) {
            _this.views.splice(index, 0, view);
          } else {
            _this.views.push(view);
          }
          view.render();
          return view;
        };
      } else {
        throw new Error("provide 'itemView' or 'makeItemView' attribute");
      }
    }).call(this);
  };

  CollectionView.prototype.getItemView = function(model) {
    var idx, view, _i, _len, _ref1;

    _ref1 = this.views;
    for (idx = _i = 0, _len = _ref1.length; _i < _len; idx = ++_i) {
      view = _ref1[idx];
      if (view.model.cid === model.cid) {
        return view;
      }
    }
  };

  CollectionView.prototype.onReset = function() {
    var _this = this;

    this.trigger('reset:before');
    this.removeViews();
    this.collection.forEach(function(model) {
      return _this.makeItemView(model).appendTo(_this.el);
    });
    return this.trigger('reset');
  };

  CollectionView.prototype.onSort = function() {
    var $cur,
      _this = this;

    this.trigger('sort:before');
    $cur = void 0;
    this.collection.forEach(function(model, newIdx) {
      var idx, view;

      view = _this.getItemView(model);
      idx = _this.views.indexOf(view);
      _this.views.splice(idx, 1)[0];
      _this.views.splice(newIdx, 0, view);
      if (!$cur) {
        return view.appendTo(_this);
      } else {
        view.after($cur);
        return $cur = view.$el;
      }
    });
    return this.trigger('sort');
  };

  CollectionView.prototype.onAdd = function(model) {
    var idx, view;

    idx = this.collection.indexOf(model);
    view = this.makeItemView(model, idx);
    this.trigger('add:before', view);
    if (idx >= this.$el.children().size()) {
      view.appendTo(this);
    } else {
      view.appendBefore(this.$el.children().eq(idx));
    }
    return this.trigger('add', view);
  };

  CollectionView.prototype.onRemove = function(model) {
    var view;

    view = this.getItemView(model);
    if (view) {
      this.trigger('remove:before', view);
      this.removeView(view);
      return this.trigger('remove', view);
    }
  };

  return CollectionView;

})(exports.View);
