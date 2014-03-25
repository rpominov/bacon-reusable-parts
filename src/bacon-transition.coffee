# Taken from https://github.com/pozadi/bacon-reusable-parts
# License: MIT

do (exports = (window.baconUtils or= {})) ->


  # Basic example:
  #
  # opacityTr = transition({hidden: 0, visible: 1}, 'hidden', 500)
  # opacityTr.value.assign($el, 'css', 'opacity')
  #
  # # later ...
  # opacityTr.setState('visible')
  #
  # # later ...
  # opacityTr.setState('hidden')


  # Different durations:
  #
  # opacityTr = transition({
  #   hidden: {
  #     val: 0,
  #     duration: 0
  #   },
  #   visible: 1
  # }, 'hidden', 300)


  exports.transition = (states, curState, defaultDuration = 300, tick=16) ->

    stateBus = new Bacon.Bus
    state = stateBus.skipDuplicates().toProperty(curState)

    getValue = (state) ->
      if (typeof state) is 'number' then state else state.val

    getDuration = (state) ->
      if state.duration? then state.duration else defaultDuration

    setState = (x) -> stateBus.push(x)

    value = state
      .changes()
      .flatMapLatest (name) ->
        targetVal = getValue(states[name])
        steps = Math.round(getDuration(states[name]) / tick)
        Bacon.sequentially(tick, [steps..0]).map (n) ->
          (curVal) ->
            curVal + (targetVal - curVal) / (n + 1)
      .scan states[curState].val, (curVal, f) -> f(curVal)

    {setState, state, value}
