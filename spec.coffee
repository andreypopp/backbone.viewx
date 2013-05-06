{Collection, Model} = Backbone = require 'backbone'
$ = Backbone.$ = require 'jquery'
{View, CollectionView} = require './backbone.viewx'
{equal, ok} = require 'assert'

describe 'backbone.viewx', ->

  $body = $('body')

  beforeEach ->
    $body.html('')

  describe 'View', ->

    describe 'subview management', ->

      class MyView extends View
        initialize: ->
          this.a = @view new View

      it 'stores subviews in viewsByCid index', ->
        view = new MyView()
        equal view.viewsByCid[view.a.cid], view.a

      it 'removes subviews on view remove', ->
        view = new MyView()
        view.remove()
        equal view.viewsByCid[view.a.cid], undefined

    describe 'DOM insertion methods', ->

      class MyView extends View
        inDOM: false

        onEnterDOM: ->
          this.inDOM = true

      describe 'appendTo()', ->

        it 'appends to a DOM element', ->
          $body.append $ '<a></a>'
          view = (new MyView).render().appendTo($body)
          equal $body.html(), '<a></a><div></div>'
          ok view.inDOM

        it 'appends to a view DOM element', ->
          parent = new MyView
          parent.$el.append $ '<a></a>'
          view = (new MyView).render().appendTo(parent)
          equal parent.$el.html(), '<a></a><div></div>'
          ok not view.inDOM

      describe 'prependTo()', ->

        it 'prepends to a DOM element', ->
          $body.append $ '<a></a>'
          view = (new MyView).render().prependTo($body)
          equal $body.html(), '<div></div><a></a>'
          ok view.inDOM

        it 'prepends to a view DOM element', ->
          parent = new MyView
          parent.$el.append $ '<a></a>'
          view = (new MyView).render().prependTo(parent)
          equal parent.$el.html(), '<div></div><a></a>'
          ok not view.inDOM

      describe 'appendAfter()', ->

        it 'appends after a DOM element', ->
          $point = $ '<a></a>'
          $body.append $point
          view = (new MyView).render().appendAfter($point)
          equal $body.html(), '<a></a><div></div>'
          ok view.inDOM

        it 'appends after a view DOM element', ->
          point = (new MyView(tagName: 'a')).render()
          $body.append point.$el
          view = (new MyView).render().appendAfter(point)
          equal $body.html(), '<a></a><div></div>'
          ok view.inDOM

      describe 'prependAfter()', ->

        it 'prepends after a DOM element', ->
          $point = $ '<a></a>'
          $body.append $point
          view = (new MyView).render().appendBefore($point)
          equal $body.html(), '<div></div><a></a>'
          ok view.inDOM

        it 'prepends after a view DOM element', ->
          point = (new MyView(tagName: 'a')).render()
          $body.append point.$el
          view = (new MyView).render().appendBefore(point)
          equal $body.html(), '<div></div><a></a>'
          ok view.inDOM

      describe 'append()', ->

        it 'appends a DOM element', ->
          view = (new MyView).render()
          view.$el.append $ '<div></div>'
          view.append $ '<a></a>'
          equal view.$el.html(), '<div></div><a></a>'
          ok not view.inDOM

        it 'appends a view DOM element', ->
          view = (new MyView).render()
          view.$el.append $ '<div></div>'
          view.append (new MyView(tagName: 'a')).render()
          equal view.$el.html(), '<div></div><a></a>'
          ok not view.inDOM

      describe 'prepend()', ->

        it 'prepends a DOM element', ->
          view = (new MyView).render()
          view.$el.append $ '<div></div>'
          view.prepend $ '<a></a>'
          equal view.$el.html(), '<a></a><div></div>'
          ok not view.inDOM

        it 'prepends a view DOM element', ->
          view = (new MyView).render()
          view.$el.append $ '<div></div>'
          view.prepend (new MyView(tagName: 'a')).render()
          equal view.$el.html(), '<a></a><div></div>'
          ok not view.inDOM

      describe 'after()', ->

        it 'appends a DOM element after', ->
          view = (new MyView).render()
          $body.append view.$el
          view.after $ '<a></a>'
          equal $body.html(), '<div></div><a></a>'

        it 'appends a view DOM element after', ->
          view = (new MyView).render()
          $body.append view.$el
          view.after (new MyView(tagName: 'a')).render()
          equal $body.html(), '<div></div><a></a>'

      describe 'before()', ->

        it 'appends a DOM element before', ->
          view = (new MyView).render()
          $body.append view.$el
          view.before $ '<a></a>'
          equal $body.html(), '<a></a><div></div>'

        it 'appends a view DOM element before', ->
          view = (new MyView).render()
          $body.append view.$el
          view.before (new MyView(tagName: 'a')).render()
          equal $body.html(), '<a></a><div></div>'

    describe 'CollectionView', ->

      makeCollection = ->
        c = new Collection [], {comparator: (model) -> model.get 'ord'}
        c.add new Model(name: 'a', ord: 1), {sort: false}
        c.add new Model(name: 'b', ord: 2), {sort: false}
        c.add new Model(name: 'c', ord: 0), {sort: false}

      collection = makeCollection()

      class MyView extends CollectionView
        itemView: class extends View
          render: ->
            this.$el.html(this.model.get('name'))

      it 'should render a collection', ->
        v = new MyView(collection: collection).render()
        equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'

      it 'should re-render collection on reset', ->
        collection = makeCollection()
        v = new MyView(collection: collection).render()
        equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
        collection.reset([new Model(name: 'x')])
        equal v.$el.html(), '<div>x</div>'

      it 'should re-order item views on sort', ->
        collection = makeCollection()
        v = new MyView(collection: collection).render()
        equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
        collection.sort()
        equal v.$el.html(), '<div>c</div><div>a</div><div>b</div>'

      describe 'add to collection', ->

        it 'should react on add new item to the end of the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.add new Model(name: 'd'), {sort: false}
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div><div>d</div>'

        it 'should react on add new item to the start of the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.add new Model(name: 'd'), {at: 0}
          equal v.$el.html(), '<div>d</div><div>a</div><div>b</div><div>c</div>'

        it 'should react on add new item by index to the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.add new Model(name: 'd'), {at: 2}
          equal v.$el.html(), '<div>a</div><div>b</div><div>d</div><div>c</div>'

      describe 'remove from collection', ->

        it 'should react on remove item from the start of the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.remove(collection.at(0))
          equal v.$el.html(), '<div>b</div><div>c</div>'

        it 'should react on remove item from the end of the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.remove(collection.last())
          equal v.$el.html(), '<div>a</div><div>b</div>'

        it 'should react on remove item from the middle of the collection', ->
          collection = makeCollection()
          v = new MyView(collection: collection).render()
          equal v.$el.html(), '<div>a</div><div>b</div><div>c</div>'
          collection.remove(collection.at(1))
          equal v.$el.html(), '<div>a</div><div>c</div>'
