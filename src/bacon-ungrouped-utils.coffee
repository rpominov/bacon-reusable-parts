# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

do (exports = (window.baconUtils or= {})) ->

  exports.escPresses = (el) ->
    $(el).asEventStream('keydown').filter (e) ->
      e.which is 27

  exports.winEscPresses = exports.escPresses(window)
