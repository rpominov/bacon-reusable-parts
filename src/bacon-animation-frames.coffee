do (exports = (window.baconUtils or= {})) ->

  exports.animationFrames = Bacon.fromBinder (sink) ->
    request =
      window.requestAnimationFrame        or
      window.webkitRequestAnimationFrame  or
      window.mozRequestAnimationFrame     or
      window.oRequestAnimationFrame       or
      window.msRequestAnimationFrame      or
      (f) -> window.setTimeout(f, 1000 / 60)
    subscribed = true
    handler = ->
      if subscribed
        sink()
        request handler
    request handler
    ->
      subscribed = false
