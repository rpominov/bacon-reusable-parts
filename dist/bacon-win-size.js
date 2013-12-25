/*
 * Taken from https://github.com/pozadi/grunt-reusable-parts
 * License: MIT
 * Built at: 2013-12-25 22:53:01 +0400
 */

(function(exports) {
  var $document, $window, resizes, size;
  $window = $(window);
  $document = $(document);
  size = function(o) {
    return {
      width: o.width(),
      height: o.height()
    };
  };
  resizes = exports.windowResizes = $window.asEventStream('resize').throttle(500);
  exports.windowSize = resizes.map(function() {
    return size($window);
  }).toProperty(size($window));
  return exports.documentSize = resizes.map(function() {
    return size($document);
  }).toProperty(size($document));
})((window.baconUtils || (window.baconUtils = {})));
