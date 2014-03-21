/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-03-21 20:04:37 +0400
 */

(function(exports) {
  var $document, $window, globalRecalculateRequests, toProp;
  toProp = function(stream, getter) {
    return stream.map(getter).toProperty(getter());
  };
  $window = $(window);
  $document = $(document);
  exports.viewportTop = toProp($window.asEventStream('scroll'), function() {
    return $window.scrollTop();
  });
  exports.viewportHeight = toProp($window.asEventStream('resize').throttle(250), function() {
    return $window.height();
  });
  exports.documentHeight = toProp(Bacon.interval(250), function() {
    return $document.height();
  }).skipDuplicates();
  exports.viewportBottom = exports.viewportTop.combine(exports.viewportHeight, function(top, height) {
    return top + height;
  });
  globalRecalculateRequests = new Bacon.Bus();
  globalRecalculateRequests.plug(exports.documentHeight.changes());
  exports.recalculateLocations = function() {
    return globalRecalculateRequests.push();
  };
  exports.createAbstract = function(top, height) {
    var api;
    if (top == null) {
      top = 0;
    }
    if (height == null) {
      height = 0;
    }
    api = {};
    api.locationBus = new Bacon.Bus();
    api.state = Bacon.combineWith(function(_arg, vpT, vpB) {
      var bottom, height, isAboveViewport, isBelowViewport, top;
      top = _arg.top, height = _arg.height;
      bottom = top + height;
      isAboveViewport = top < vpT;
      isBelowViewport = bottom > vpB;
      return {
        top: top,
        bottom: bottom,
        height: height,
        isAboveViewport: isAboveViewport,
        isBelowViewport: isBelowViewport,
        isInViewport: top <= vpB && bottom >= vpT,
        isFullyInViewport: top >= vpT && bottom <= vpB,
        isSpansViewport: isAboveViewport && isBelowViewport
      };
    }, api.locationBus.toProperty({
      top: top,
      height: height
    }), exports.viewportTop, exports.viewportBottom);
    return api;
  };
  return exports.create = function(el, offsets) {
    var $el, api, locked, recalculateRequests;
    if (offsets == null) {
      offsets = {
        top: 0,
        bottom: 0
      };
    }
    $el = $(el);
    api = exports.createAbstract();
    api.offsets = offsets;
    locked = false;
    api.lock = function() {
      return locked = true;
    };
    api.unlock = function() {
      return locked = false;
    };
    recalculateRequests = new Bacon.Bus;
    recalculateRequests.plug(globalRecalculateRequests.filter(function() {
      return !locked;
    }));
    api.recalculateLocation = function() {
      return recalculateRequests.push();
    };
    api.locationBus.plug(toProp(recalculateRequests, function() {
      return {
        top: $el.offset().top - api.offsets.top,
        height: $el.outerHeight() + api.offsets.bottom
      };
    }));
    return api;
  };
})((window.baconUtils || (window.baconUtils = {})).scrollMonitor = {});
