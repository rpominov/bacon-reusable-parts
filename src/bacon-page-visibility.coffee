do (exports = (window.baconUtils or= {})) ->

  if typeof document.hidden isnt "undefined"
    hidden = "hidden"
    visibilityChange = "visibilitychange"
  else if typeof document.mozHidden isnt "undefined"
    hidden = "mozHidden"
    visibilityChange = "mozvisibilitychange"
  else if typeof document.msHidden isnt "undefined"
    hidden = "msHidden"
    visibilityChange = "msvisibilitychange"
  else if typeof document.webkitHidden isnt "undefined"
    hidden = "webkitHidden"
    visibilityChange = "webkitvisibilitychange"

  if hidden?
    getValue = ->
      !document[hidden]
    exports.pageVisibility = $(document)
      .asEventStream(visibilityChange, getValue)
      .skipDuplicates()
      .toProperty(getValue())
  else
    exports.pageVisibility = Bacon.constant(true)
