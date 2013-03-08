###

  Backbone.Avgrund

  2013 (c) Andrey Popp <8mayday@gmail.com>

  Inspired by Avgrund modal concept by @hakimel

  2012 (c) Hakim El Hattab <http://hakim.se>

  MIT Licensed

###
((root, factory) ->
  if typeof exports == 'object'
    _ = require 'underscore'
    Backbone = require 'backbone'
    module.exports = factory(_, Backbone, require)
  else if typeof define == 'function' and define.amd
    define (require) ->
      _ = require 'underscore'
      Backbone = require 'backbone'
      root.Backbone.Avgrund = factory(_, Backbone, require)
  else
    root.Backbone.Avgrund = factory(root._, root.Backbone)

) this, ({isString}, {View, $}, require) ->

  $nodify = (node) ->
    return $(node) unless isString(node)
    parts = $.parseHTML(node)
    $nodes = $()
    for part in parts
      $nodes = $nodes.add($(part))
    $nodes



  class Avgrund extends View
    $cover: $nodify('<div></div>')
    $document: undefined

    constructor: ->
      super
      this.$el.addClass('avgrund-popup')
      this.$cover = $nodify(this.$cover)
      this.$cover.addClass('avgrund-cover')

    ensureReferences: ->
      this.$document = $(document.documentElement)
        .addClass('avgrund-ready') unless this.$document
      this.$body = $(document.body) unless this.$body

    show: ->
      this.ensureReferences()
      this.$document.on
        'keyup.avgrund': this.onDocumentKeyUp.bind(this)
        'click.avgrund': this.onDocumentClick.bind(this)
        'touchstart.avgrund': this.onDocumentClick.bind(this)
      this.$body.append(this.$cover)
      console.log this.$cover.length

      this.$el.addClass('avgrund-popup-animate')
      this.$el.removeClass(this.currentState)
      this.$el.addClass('no-transition')

      setTimeout =>
        this.$el.removeClass('no-transition')
        this.$document.addClass('avgrund-active')

      this

    hide: ->
      this.ensureReferences()
      this.$document.off('.avgrund')
      this.$document.removeClass('avgrund-active')
      this.$el.removeClass('avgrund-popup-animate')
      this.$cover.detach()
      this

    onDocumentKeyUp: (e) ->
      this.hide() if e.keyCode == 27

    onDocumentClick: (e) ->
      this.hide() if $(e.target).is(this.$cover)
