# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

do (exports = (window.baconUtils or= {})) ->

  $window = $(window)
  $document = $(document)

  exports.windowResizes = $window.asEventStream('resize').throttle(250)

  prop = (getValue) ->
    exports.windowResizes.map(getValue).toProperty getValue()

  size = ($el) ->
    width: $el.width()
    height: $el.height()

  exports.windowSize = prop -> size $window
  exports.documentSize = prop -> size $document
  exports.windowWidth = prop -> $window.width()
  exports.windowHeight = prop -> $window.height()
  exports.documentWidth = prop -> $document.width()
  exports.documentHeight = prop -> $document.height()
