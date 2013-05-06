{extend} = require 'underscore'
{View, $} = require 'backbone'

contains = (doc, el) ->
  (doc.contains or $.contains)(doc, el)

exports.DOMInsertionMethods = 

  prependTo: (el) ->
    $(el.el or el).prepend(this.el)
    this.callOnEnterDOM() if contains(this.el.ownerDocument.body, this.el)
    this

  appendTo: (el) ->
    $(el.el or el).append(this.el)
    this.callOnEnterDOM() if contains(this.el.ownerDocument.body, this.el)
    this

  appendAfter: (el) ->
    $(el.el or el).after(this.el)
    this.callOnEnterDOM() if contains(this.el.ownerDocument.body, this.el)
    this

  appendBefore: (el) ->
    $(el.el or el).before(this.el)
    this.callOnEnterDOM() if contains(this.el.ownerDocument.body, this.el)
    this

  prepend: (el) ->
    if el.el? then el.prependTo(this) else this.$el.prepend(el)
    this

  append: (el) ->
    if el.el? then el.appendTo(this) else this.$el.append(el)
    this

  after: (el) ->
    if el.el? then el.appendAfter(this) else this.$el.after(el)
    this

  before: (el) ->
    if el.el? then el.appendBefore(this) else this.$el.before(el)
    this

  callOnEnterDOM: ->
    this.onEnterDOM?()
    if this.viewsByCid?
      view.callOnEnterDOM?() for _, view of this.viewsByCid

class exports.View extends View
  extend this.prototype, exports.DOMInsertionMethods

  constructor: ->
    this.viewsByCid = {}
    super

  view: (view) ->
    this.viewsByCid[view.cid] = view
    view

  removeView: (view) ->
    this.viewsByCid[view.cid] = undefined
    view.remove()
    this

  removeViews: ->
    this.removeView(view) for _, view of this.viewsByCid
    this

  remove: ->
    super
    this.removeViews()
    this

class exports.CollectionView extends exports.View
  itemView: undefined
  makeItemView: undefined

  constructor: ->
    super
    this.views = []
    this.listenTo this.collection,
      reset: this.onReset
      sort: this.onSort
      add: this.onAdd
      remove: this.onRemove

  removeView: (view) ->
    this.viewsByCid[view.cid] = undefined
    this.views.splice(this.views.indexOf(view), 1)
    view.remove() 
    this

  render: (template) ->
    this.setupItemView(template)
    this.onReset()
    this

  setupItemView: (maybeTemplate) ->
    if this.options.itemView?
      this.itemView = this.options.itemView

    this.makeItemView = if this.makeItemView?
      this.makeItemView
    else if this.itemView?
      (model, index) =>
        view = new this.itemView(model: model)
        view = this.view(view, at: index)
        if index?
          this.views.splice(index, 0, view)
        else
          this.views.push(view)
        view.render()
        view
    else
      throw new Error("provide 'itemView' or 'makeItemView' attribute")

  getItemView: (model) ->
    for view, idx in this.views
      if view.model.cid == model.cid
        return view

  onReset: ->
    this.trigger 'reset:before'
    this.removeViews()
    this.collection.forEach (model) =>
      this.makeItemView(model).appendTo(this.el)
    this.trigger 'reset'

  onSort: ->
    this.trigger 'sort:before'
    $cur = undefined
    this.collection.forEach (model, newIdx) =>
      view = this.getItemView(model)
      idx = this.views.indexOf(view)
      this.views.splice(idx, 1)[0]
      this.views.splice(newIdx, 0, view)
      if not $cur
        view.appendTo(this)
      else
        view.after($cur)
        $cur = view.$el
    this.trigger 'sort'

  onAdd: (model) ->
    idx = this.collection.indexOf(model)
    view = this.makeItemView(model, idx)
    this.trigger 'add:before', view
    if idx >= this.$el.children().size()
      view.appendTo(this)
    else
      view.appendBefore(this.$el.children().eq(idx))
    this.trigger 'add', view

  onRemove: (model) ->
    view = this.getItemView(model)
    if view
      this.trigger 'remove:before', view
      this.removeView(view)
      this.trigger 'remove', view
