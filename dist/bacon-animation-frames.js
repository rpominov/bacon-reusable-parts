/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-02-09 02:02:25 +0400
 */

(function(exports) {
  exports.animationFrames = Bacon.fromBinder(function(sink) {
    var handler, request, subscribed;
    request = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(f) {
      return window.setTimeout(f, 1000 / 60);
    };
    subscribed = true;
    handler = function() {
      if (subscribed) {
        sink();
        return request(handler);
      }
    };
    request(handler);
    return function() {
      return subscribed = false;
    };
  });
  return exports.sampledByAnimationsFrames = function(stream) {
    var awaiting;
    awaiting = stream.awaiting(exports.animationFrames);
    return stream.sampledBy(awaiting.changes().filter(function(x) {
      return !x;
    }));
  };
})((window.baconUtils || (window.baconUtils = {})));
