backbone.viewx is a library which consist of 

* a Backbone.View subclass flavoured with sub view management routines and DOM
  insertion methods.

      {View} = require 'backbone.viewx'

      class MyView extends View

        render: ->
          this.content = @view(new Content)
            .render()
            .appendTo(this.el)
          # appendTo, prependTo, appendAfter, appendBefore # append, prepend,
          # after, before are also available

        onEnterDOM: ->
          # this method will be called when view's element is attached to the
          # DOM, useful for triggering relayout and animations

* a CollectionView for rendering Backbone.Collection

      {CollectionView} = require 'backbone.viewx'

      class MyCollectionView extends CollectionView
        tagName: 'ul'
        itemView: class extends View
          tagName: 'li'
          render: ->
            this.$el.html "#{this.model.get('name')}"

      view = (new MyCollectionView(collection: new Backbone.Collection()))
        .render()
        .appendTo(document.body)
      view.collection.add(new Backbone.Model(name: 'First')) # view updates!
