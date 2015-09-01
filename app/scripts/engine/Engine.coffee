PIXI = require('pixi')

requestAnimFrame = (->
  return window.requestAnimationFrame ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame ||
         window.oRequestAnimationFrame ||
         window.msRequestAnimationFrame ||
         -> window.setTimeout(callback, 1000.0/60.0);
)();

class Engine
  constructor: (@width, @height) ->
    @stage = new PIXI.Stage(0x001133)
    @renderer = PIXI.autoDetectRenderer(@width, @height)
    @gameContainer = new PIXI.DisplayObjectContainer()
    @stage.addChild(@gameContainer)
    @active = false
    return

  attach: (element) ->
    element.appendChild(@renderer.view);

  start: ->
    @active = true
    requestAnimFrame(=> @_animate())
    return

  stop: ->
    @active = false
    return

  _animate: ->
    if @active
      requestAnimFrame(=> @_animate())
      @renderer.render(@stage)

module.exports = Engine