/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-03-11 23:01:13 +0400
 */

(function(exports) {
  var $document, $window, prop, size;
  $window = $(window);
  $document = $(document);
  exports.windowResizes = $window.asEventStream('resize').throttle(250);
  prop = function(getValue) {
    return exports.windowResizes.map(getValue).toProperty(getValue());
  };
  size = function($el) {
    return {
      width: $el.width(),
      height: $el.height()
    };
  };
  exports.windowSize = prop(function() {
    return size($window);
  });
  exports.documentSize = prop(function() {
    return size($document);
  });
  exports.windowWidth = prop(function() {
    return $window.width();
  });
  exports.windowHeight = prop(function() {
    return $window.height();
  });
  exports.documentWidth = prop(function() {
    return $document.width();
  });
  return exports.documentHeight = prop(function() {
    return $document.height();
  });
})((window.baconUtils || (window.baconUtils = {})));
