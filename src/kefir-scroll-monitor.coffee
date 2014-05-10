# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

# inspired by https://github.com/sakabako/scrollMonitor

do (exports = (window.kefirUtils or= {}).scrollMonitor = {}) ->




  # tmp
  $::asEventStream = (name) ->
    $el = this
    send = -> result._send()
    result = new Kefir.Stream(
      (-> $el.on(name, send)),
      (-> $el.off(name, send))
    )
    result



  toProp = (stream, getter) ->
    stream.map(getter).toProperty(getter())


  $window = $(window)
  $document = $(document)


  exports.viewportTop = toProp $window.asEventStream('scroll'), ->
    $window.scrollTop()

  # exports.viewportHeight = toProp $window.asEventStream('resize').throttle(250), ->
  exports.viewportHeight = toProp $window.asEventStream('resize'), ->
    $window.height()

  exports.documentHeight = toProp(Kefir.interval(250), -> $document.height())
    # .skipDuplicates()

  exports.viewportBottom = exports.viewportTop.combine exports.viewportHeight, (top, height) ->
    top + height

  globalRecalculateRequests = new Kefir.Bus()
  globalRecalculateRequests.plug exports.documentHeight.changes()

  exports.recalculateLocations = ->
    globalRecalculateRequests.push()



  # Abstract watcher

  exports.createAbstract = (top = 0, height = 0) ->

    api = {}

    api.locationBus = new Kefir.Bus()

    api.state = Kefir.combine(
      [
        api.locationBus.toProperty({top, height})
        exports.viewportTop
        exports.viewportBottom
      ], ({top, height}, vpT, vpB) ->
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

    recalculateRequests = new Kefir.Bus
    recalculateRequests.plug(globalRecalculateRequests.filter -> !locked)

    api.recalculateLocation = ->
      recalculateRequests.push()

    api.locationBus.plug toProp recalculateRequests, ->
      top: $el.offset().top - api.offsets.top
      height: $el.outerHeight() + api.offsets.bottom

    return api
