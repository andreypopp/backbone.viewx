{View, $} = require 'backbone'

contains = (doc, el) ->
  (doc.contains or $.contains)(doc, el)

class exports.View extends View

  constructor: ->
    this.viewsByCid = {}
    super

  view: (view) ->
    this.viewsByCid[view.cid] = view
    view

  removeViews: ->
    for cid, view of this.viewsByCid
      this.viewsByCid[cid] = undefined
      view.remove() 
    this

  remove: ->
    super
    this.removeViews()
    this

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

  append: (el) ->
    if el.el? then el.appendTo(this) else this.$el.append(el)

  after: (el) ->
    if el.el? then el.appendAfter(this) else this.$el.after(el)

  before: (el) ->
    if el.el? then el.appendBefore(this) else this.$el.before(el)

  callOnEnterDOM: ->
    this.onEnterDOM?()
    if this.viewsByCid?
      view.callOnEnterDOM?() for _, view of this.viewsByCid
