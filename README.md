Backbone.View flavoured with sub view management routines and DOM insertion
methods.

    View = require 'backbone.viewx'

    class MyView extends View

      render: ->
        this.header = @view(new Header)
          .render()
          .prependTo(this.el)
        this.content = @view(new Content)
          .render()
          .appendTo(this.el)
        # appendTo, prependTo, appendAfter, appendBefore
        # and inverse methods
        # append, prepend, after, before
        # are also available

      onEnterDOM: ->
        # this method will be called when view's element is attached to the DOM,
        # useful for triggering relayout and animations
