do (exports = (window.baconUtils or= {})) ->

  $window = $(window)
  $document = $(document)

  size = (o) ->
    width: o.width()
    height: o.height()

  resizes = exports.windowResizes = $window.asEventStream('resize').throttle(500)
  exports.windowSize = resizes.map(-> size $window).toProperty size($window)
  exports.documentSize = resizes.map(-> size $document).toProperty size($document)
