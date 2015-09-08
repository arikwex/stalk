PIXI = require('pixi')
p2 = require('p2')
requestAnimFrame = require('./anim')
material = require('enum/material')

class Engine
  constructor: (@width, @height) ->
    @renderer = PIXI.autoDetectRenderer(@width, @height, antialias: true)
    @gameContainer = new PIXI.Container()
    @active = false
    @world = new p2.World(gravity: [0, 1980])
    @world.solver.iterations = 40;
    @world.solver.tolerance = 0.002;
    @entities = {}

    planeShape = new p2.Plane()
    plane = new p2.Body(
      position:[0, 700]
      angle: Math.PI
    )
    planeShape.material = material.GROUND
    plane.addShape(planeShape)
    planeShape.collisionGroup = 0x01
    planeShape.collisionMask =  0x01 | 0x02
    @world.addBody(plane)

    fric = new p2.ContactMaterial(material.GROUND, material.SHOE,
      friction: 7.0
      restitution: 0.01
    )
    @world.addContactMaterial(fric)
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

  addEntity: (entity) ->
    for body in entity.getBodies()
      @world.addBody(body)
      @gameContainer.addChild(body.graphics)
    for constraint in entity.getConstraints()
      @world.addConstraint(constraint)
    @entities[entity.id] = entity
    return

  removeEntity: (entity) ->
    for body in entity.getBodies()
      @world.removeBody(body)
      @gameContainer.removeChild(body.graphics)
    for constraint in entity.getConstraints()
      @world.removeConstraint(constraint)
    delete @entities[entity.id]
    return

  step: (dT) ->
    for id, entity of @entities
      entity.update(dT, @)
      entity.render()

  _animate: ->
    if @active
      now = +new Date()
      if not @_lastTime
        @_lastTime = now - 50
      dT = (now - @_lastTime) / 1000.0
      requestAnimFrame(=> @_animate())
      @step(dT)
      @world.step(dT)
      @renderer.render(@gameContainer)
      @_lastTime = +new Date()

module.exports = Engine