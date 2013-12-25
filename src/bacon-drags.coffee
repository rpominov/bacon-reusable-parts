do (exports = (window.baconUtils or= {}).drags = {}) ->

  id = (x) -> x

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
            else id
        )

  exports.isHorizontal = (move) ->
    Math.abs(move.dX / move.dY) > 1.2

  exports.isVertical = (move) ->
    Math.abs(move.dY / move.dX) > 1.2

  exports.mouseDrags = (el, preventDefault) ->
    abstractMoves(
      $(el).asEventStream('mousedown'),
      $('body').asEventStream('mousemove'),
      $('body').asEventStream('mouseup'),
      preventDefault
    )

  exports.swipes = (el, preventDefault) ->
    abstractMoves(
      $(el).asEventStream('touchstart'),
      $('body').asEventStream('touchmove'),
      $('body').asEventStream('touchend'),
      preventDefault
    )

  exports.swipesAndDrags = (el, preventDefault) ->
    Bacon.mergeAll(
      exports.mouseDrags(el, preventDefault),
      exports.swipes(el, preventDefault)
    )
