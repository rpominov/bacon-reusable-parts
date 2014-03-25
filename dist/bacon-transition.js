/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-03-25 19:45:09 +0400
 */

(function(exports) {
  return exports.transition = function(states, curState, defaultDuration, tick) {
    var getDuration, getValue, setState, state, stateBus, value;
    if (defaultDuration == null) {
      defaultDuration = 300;
    }
    if (tick == null) {
      tick = 16;
    }
    stateBus = new Bacon.Bus;
    state = stateBus.skipDuplicates().toProperty(curState);
    getValue = function(state) {
      if ((typeof state) === 'number') {
        return state;
      } else {
        return state.val;
      }
    };
    getDuration = function(state) {
      if (state.duration != null) {
        return state.duration;
      } else {
        return defaultDuration;
      }
    };
    setState = function(x) {
      return stateBus.push(x);
    };
    value = state.changes().flatMapLatest(function(name) {
      var steps, targetVal, _i, _results;
      targetVal = getValue(states[name]);
      steps = Math.round(getDuration(states[name]) / tick);
      return Bacon.sequentially(tick, (function() {
        _results = [];
        for (var _i = steps; steps <= 0 ? _i <= 0 : _i >= 0; steps <= 0 ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this)).map(function(n) {
        return function(curVal) {
          return curVal + (targetVal - curVal) / (n + 1);
        };
      });
    }).scan(states[curState].val, function(curVal, f) {
      return f(curVal);
    });
    return {
      setState: setState,
      state: state,
      value: value
    };
  };
})((window.baconUtils || (window.baconUtils = {})));
