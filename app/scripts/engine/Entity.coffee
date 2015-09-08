Renderer = require('./Renderer')
PIXI = require('pixi')
p2 = require('p2')
Vis = require('./visualization')

class Entity
  constructor: ->
    @id = (Math.random()).toString(16).substr(2)
    @bodies = []
    @constraints = []
    @setVisualization(Vis)
    return

  setVisualization: (@visualization) ->

  addBox: (options) ->
    shape = new p2.Box(
      width: options.width
      height: options.height
      collisionGroup: options.group
      collisionMask: options.mask
    )
    body = new p2.Body(
      mass: options.mass
      position: [options.position[0], options.position[1]]
      fixedX: options.fixedX || false
      fixedY: options.fixedY || false
      fixedRotation: options.fixedRotation || false
    )
    shape.material = options.material
    body.addShape(shape)
    body.graphics = new PIXI.Graphics()
    @bodies.push(body)
    return body

  addCircle: (options) ->
    shape = new p2.Circle(
      radius: options.radius
      collisionGroup: options.group
      collisionMask: options.mask
    )
    body = new p2.Body(
      mass: options.mass
      position: [options.position[0], options.position[1]]
    )
    shape.material = options.material
    body.addShape(shape)
    body.graphics = new PIXI.Graphics()
    @bodies.push(body)
    return body

  addConstraint: (constraint) ->
    @constraints.push(constraint)
    return

  update: (dT, engine) ->
    return

  render: ->
    @visualization.render(@)
    return

  getBodies: -> @bodies

  getConstraints: -> @constraints


module.exports = Entity