/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-03-21 20:02:48 +0400
 */

(function(exports) {
  var $document, $window, documentResizes, prop;
  $window = $(window);
  exports.windowResizes = $window.asEventStream('resize').throttle(250);
  prop = function(getValue) {
    return exports.windowResizes.map(getValue).toProperty(getValue());
  };
  exports.windowWidth = prop(function() {
    return $window.width();
  });
  exports.windowHeight = prop(function() {
    return $window.height();
  });
  exports.windowSize = Bacon.combineTemplate({
    width: exports.windowWidth,
    height: exports.windowHeight
  });
  $document = $(document);
  documentResizes = Bacon.interval(250);
  prop = function(getValue) {
    return documentResizes.map(getValue).toProperty(getValue()).skipDuplicates();
  };
  exports.documentWidth = prop(function() {
    return $document.width();
  });
  exports.documentHeight = prop(function() {
    return $document.height();
  });
  return exports.documentSize = Bacon.combineTemplate({
    width: exports.documentWidth,
    height: exports.documentHeight
  });
})((window.baconUtils || (window.baconUtils = {})));
