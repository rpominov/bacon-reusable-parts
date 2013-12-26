/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2013-12-26 14:10:58 +0400
 */

(function(exports) {
  return exports.animationFrames = Bacon.fromBinder(function(sink) {
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
})((window.baconUtils || (window.baconUtils = {})));
