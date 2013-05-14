{View} = require './view'

class exports.CollectionView extends View
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
        if this.options.reverse
          if index?
            this.views.splice(this.views.length - index - 1, 0, view)
          else
            this.views.unshift(view)
        else
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
      if this.options.reverse
        this.makeItemView(model).prependTo(this.el)
      else
        this.makeItemView(model).appendTo(this.el)
    this.trigger 'reset'

  onSort: ->
    this.trigger 'sort:before'
    $cur = undefined
    this.collection.forEach (model, newIdx) =>
      view = this.getItemView(model)
      idx = this.views.indexOf(view)
      this.views.splice(idx, 1)[0]
      if this.options.reverse
        this.views.splice(this.views.length - newIdx - 1, 0, view)
        if not $cur
          view.prependTo(this)
        else
          view.before($cur)
          $cur = view.$el
      else
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
    size = this.$el.children().size()
    if this.options.reverse
      if idx >= size
        view.prependTo(this)
      else
        view.appendAfter(this.$el.children().eq(size - idx - 1))
    else
      if idx >= size
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
