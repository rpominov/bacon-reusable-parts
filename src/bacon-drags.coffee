# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

do (exports = (window.baconUtils or= {}).drags = {}) ->

  getPos = (e) ->
    source = (if e.originalEvent.touches
      e.originalEvent.touches[0]
    else
      e.originalEvent)
    x: source.clientX
    y: source.clientY
    event: e

  deltas = (prev, next) ->
    dX: next.x - prev.x
    dY: next.y - prev.y
    event: next.event

  preventHorisontal = (move) ->
    if exports.isHorizontal(move)
      move.event.preventDefault()
    move
  preventVertical = (move) ->
    if exports.isVertical(move)
      move.event.preventDefault()
    move
  preventBoth = (move) ->
    move.event.preventDefault()
    move

  abstractMoves = (starts, moves, ends, preventDefault = false) ->
    starts.map (e) ->
      moves
        .takeUntil(ends)
        .map(getPos)
        .diff(getPos(e), deltas)
        .map(
          switch preventDefault
            when 'horizontal' then preventHorisontal
            when 'vertical' then preventVertical
            when 'both' then preventBoth
            else Bacon._.id
        )

  exports.isHorizontal = (move) ->
    Math.abs(move.dX / move.dY) > 1.2

  exports.isVertical = (move) ->
    Math.abs(move.dY / move.dX) > 1.2

  documentMouseMoves = $(document).asEventStream('mousemove')
  documentMouseUps = $(document).asEventStream('mouseup')

  exports.mouseDrags = (el, preventDefault) ->
    abstractMoves(
      $(el).asEventStream('mousedown'),
      documentMouseMoves,
      documentMouseUps,
      preventDefault
    )

  documentTouchMoves = $(document).asEventStream('touchmove')
  documentTouchEnds = $(document).asEventStream('touchend')

  exports.swipes = (el, preventDefault) ->
    abstractMoves(
      $(el).asEventStream('touchstart'),
      documentTouchMoves,
      documentTouchEnds,
      preventDefault
    )

  exports.swipesAndDrags = (el, preventDefault) ->
    Bacon.mergeAll(
      exports.mouseDrags(el, preventDefault),
      exports.swipes(el, preventDefault)
    )
