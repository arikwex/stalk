p2 = require('p2')
Entity = require('engine/Entity')
collision = require('enum/collision')
plant = require('enum/plant')

visualizations = {}
visualizations[plant.EVERGROW] = require('./visualizations/evergrow')

class Plant extends Entity
  constructor: (@type, pose) ->
    super()
    @setVisualization(visualizations[@type])
    @base = @addBox(
      width: 40
      height: 1
      position: [pose.x, pose.y]
      mass: 0.01
    )
    @base.angle = pose.angle
    return

  lockToGround: (bodies) ->
    groundBodies = []
    for body in bodies
      if body.isTerrain
        groundBodies.push(body)
    ray = new p2.Ray(
      collisionGroup: collision.GROUND
      collisionMask: collision.GROUND
      mode: p2.Ray.CLOSEST
    )
    ray.from = [@base.position[0] , @base.position[1]]
    ray.to = [@base.position[0] + Math.cos(@base.angle + Math.PI/2) * 10
              @base.position[1] + Math.sin(@base.angle + Math.PI/2) * 10]
    ray.update()
    rayResult = new p2.RaycastResult()
    ray.intersectBodies(rayResult, groundBodies)
    if rayResult.body?
      constraint = new p2.LockConstraint(@base, rayResult.body)
      @addConstraint(constraint)
    return

  addBox: (options) ->
    options.group = options.group || collision.PLANT
    options.mask = options.mask || collision.GROUND
    super(options)

module.exports = Plant