/*
 * Taken from https://github.com/pozadi/bacon-reusable-parts
 * License: MIT
 * Built at: 2014-02-07 20:47:14 +0400
 */

(function(exports) {
  var getValue, hidden, visibilityChange;
  if (typeof document.hidden !== "undefined") {
    hidden = "hidden";
    visibilityChange = "visibilitychange";
  } else if (typeof document.mozHidden !== "undefined") {
    hidden = "mozHidden";
    visibilityChange = "mozvisibilitychange";
  } else if (typeof document.msHidden !== "undefined") {
    hidden = "msHidden";
    visibilityChange = "msvisibilitychange";
  } else if (typeof document.webkitHidden !== "undefined") {
    hidden = "webkitHidden";
    visibilityChange = "webkitvisibilitychange";
  }
  if (hidden != null) {
    getValue = function() {
      return !document[hidden];
    };
    return exports.pageVisibility = $(document).asEventStream(visibilityChange, getValue).skipDuplicates().toProperty(getValue());
  } else {
    return exports.pageVisibility = Bacon.constant(true);
  }
})((window.baconUtils || (window.baconUtils = {})));
