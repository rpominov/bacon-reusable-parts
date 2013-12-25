/*
 * Taken from https://github.com/pozadi/grunt-reusable-parts
 * License: MIT
 * Built at: 2013-12-25 22:53:01 +0400
 */

(function(exports) {
  var abstractMoves, deltas, getPos, id, preventBoth, preventHorisontal, preventVertical;
  id = function(x) {
    return x;
  };
  getPos = function(e) {
    var source;
    source = (e.originalEvent.touches ? e.originalEvent.touches[0] : e.originalEvent);
    return {
      x: source.clientX,
      y: source.clientY,
      event: e
    };
  };
  deltas = function(prev, next) {
    return {
      dX: next.x - prev.x,
      dY: next.y - prev.y,
      event: next.event
    };
  };
  preventHorisontal = function(move) {
    if (exports.isHorizontal(move)) {
      move.event.preventDefault();
    }
    return move;
  };
  preventVertical = function(move) {
    if (exports.isVertical(move)) {
      move.event.preventDefault();
    }
    return move;
  };
  preventBoth = function(move) {
    move.event.preventDefault();
    return move;
  };
  abstractMoves = function(starts, moves, ends, preventDefault) {
    if (preventDefault == null) {
      preventDefault = false;
    }
    return starts.map(function(e) {
      return moves.takeUntil(ends).map(getPos).diff(getPos(e), deltas).map((function() {
        switch (preventDefault) {
          case 'horizontal':
            return preventHorisontal;
          case 'vertical':
            return preventVertical;
          case 'both':
            return preventBoth;
          default:
            return id;
        }
      })());
    });
  };
  exports.isHorizontal = function(move) {
    return Math.abs(move.dX / move.dY) > 1.2;
  };
  exports.isVertical = function(move) {
    return Math.abs(move.dY / move.dX) > 1.2;
  };
  exports.mouseDrags = function(el, preventDefault) {
    return abstractMoves($(el).asEventStream('mousedown'), $('body').asEventStream('mousemove'), $('body').asEventStream('mouseup'), preventDefault);
  };
  exports.swipes = function(el, preventDefault) {
    return abstractMoves($(el).asEventStream('touchstart'), $('body').asEventStream('touchmove'), $('body').asEventStream('touchend'), preventDefault);
  };
  return exports.swipesAndDrags = function(el, preventDefault) {
    return Bacon.mergeAll(exports.mouseDrags(el, preventDefault), exports.swipes(el, preventDefault));
  };
})((window.baconUtils || (window.baconUtils = {})).drags = {});
