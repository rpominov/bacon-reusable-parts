# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

# inspired by https://github.com/sakabako/scrollMonitor

do (exports = (window.baconUtils or= {}).scrollMonitor = {}) ->


  toProp = (stream, getter) ->
    stream.map(getter).toProperty(getter())


  $window = $(window)
  $document = $(document)


  exports.viewportTop = toProp $window.asEventStream('scroll').debounceImmediate(50), ->
    $window.scrollTop()

  exports.viewportHeight = toProp $window.asEventStream('resize').debounceImmediate(250), ->
    $window.height()

  exports.documentHeight = toProp(Bacon.interval(250), -> $document.height())
    .skipDuplicates()

  exports.viewportBottom = exports.viewportTop.combine exports.viewportHeight, (top, height) ->
    top + height

  globalRecalculateRequests = new Bacon.Bus()
  globalRecalculateRequests.plug exports.documentHeight.changes()

  exports.recalculateLocations = ->
    globalRecalculateRequests.push()



  # Abstract watcher

  exports.createAbstract = (top = 0, height = 0) ->

    api = {}

    api.locationBus = new Bacon.Bus()

    api.state = Bacon.combineWith(
      ({top, height}, vpT, vpB) ->
        bottom = top + height
        isAboveViewport = top < vpT
        isBelowViewport = bottom > vpB
        {
          top,
          bottom,
          height,

          # true if any part of the element is above the viewport
          isAboveViewport,

          # true if any part of the element is below the viewport
          isBelowViewport,

          # true if any part of the element is visible
          isInViewport: top <= vpB and bottom >= vpT

          # true if the entire element is visible
          isFullyInViewport: top >= vpT and bottom <= vpB

          # true when the element spans the entire viewport
          # (in case the element is larger than the viewport)
          isSpansViewport: isAboveViewport and isBelowViewport
        }
      , api.locationBus.toProperty({top, height})
      , exports.viewportTop
      , exports.viewportBottom
    )

    return api



  # Element watcher

  exports.create = (el, offsets = {top: 0, bottom: 0}) ->

    $el = $(el)

    api = exports.createAbstract()

    api.offsets = offsets

    locked = false

    api.lock = ->
      locked = true

    api.unlock = ->
      locked = false

    recalculateRequests = new Bacon.Bus
    recalculateRequests.plug(globalRecalculateRequests.filter -> !locked)

    api.recalculateLocation = ->
      recalculateRequests.push()

    api.locationBus.plug toProp recalculateRequests, ->
      top: $el.offset().top - api.offsets.top
      height: $el.height() + api.offsets.bottom

    return api
