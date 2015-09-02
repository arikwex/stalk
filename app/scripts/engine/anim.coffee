requestAnimFrame = (->
  return window.requestAnimationFrame ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame ||
         window.oRequestAnimationFrame ||
         window.msRequestAnimationFrame ||
         -> window.setTimeout(callback, 1000.0/60.0);
)();

module.exports = requestAnimationFrame