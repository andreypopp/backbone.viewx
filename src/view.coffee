{extend} = require 'underscore'
{View, $} = require 'backbone'

contains = (doc, el) ->
  if doc.contains?
    doc.contains(el)
  else
    $.contains(doc, el)

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
    this.removeView(view) for _, view of extend({}, this.viewsByCid)
    this

  remove: ->
    super
    this.removeViews()
    this

