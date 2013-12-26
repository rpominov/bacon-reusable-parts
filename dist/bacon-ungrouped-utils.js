/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2013-12-26 14:10:33 +0400
 */

(function(exports) {
  exports.escPresses = function(el) {
    return $(el).asEventStream('keydown').filter(function(e) {
      return e.which === 27;
    });
  };
  return exports.winEscPresses = exports.escPresses(window);
})((window.baconUtils || (window.baconUtils = {})));
