# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

do (exports = (window.baconUtils or= {})) ->



  $window = $(window)

  exports.windowResizes = $window.asEventStream('resize').debounceImmediate(250)

  prop = (getValue) ->
    exports.windowResizes.map(getValue).toProperty getValue()

  exports.windowWidth = prop -> $window.width()
  exports.windowHeight = prop -> $window.height()
  exports.windowSize = Bacon.combineTemplate {
    width: exports.windowWidth
    height: exports.windowHeight
  }



  $document = $(document)

  documentResizes = Bacon.interval(250)

  prop = (getValue) ->
    documentResizes.map(getValue).toProperty(getValue()).skipDuplicates()

  exports.documentWidth = prop -> $document.width()
  exports.documentHeight = prop -> $document.height()
  exports.documentSize = Bacon.combineTemplate {
    width: exports.documentWidth
    height: exports.documentHeight
  }
