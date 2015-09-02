Entity = require('engine/Entity')
Vis = require('./visualization')
collision = require('enum/collision')
p2 = require('p2')
material = require('enum/material')

class Character extends Entity
  constructor: (options) ->
    super()
    { @x
      @y } = options
    @wait = 0

    @head = @addCircle(
      radius: 18
      position: [@x, @y - 50]
      mass: 1
    )
    @torso = @addCircle(
      radius: 20
      position: [@x, @y]
      mass: 1
    )
    @foot1 = @addCircle(
      radius: 13
      position: [@x, @y + 50]
      mass: 1
      material: material.SHOE
    )
    @foot2 = @addCircle(
      radius: 13
      position: [@x, @y + 50]
      mass: 1
      material: material.SHOE
    )
    @hand1 = @addCircle(
      radius: 10
      position: [@x, @y]
      mass: 1
      material: material.LIMB
    )
    @hand2 = @addCircle(
      radius: 10
      position: [@x, @y]
      mass: 1
      material: material.LIMB
    )

    @neckJoint = new p2.RevoluteConstraint(@head, @torso,
      localPivotA: [0, 20],
      localPivotB: [0, -30]
    )
    @neckJoint.setLimits(-Math.PI / 6, Math.PI / 6);
    @addConstraint(@neckJoint)

    @kneeJoint1 = new p2.RevoluteConstraint(@foot1, @torso,
      localPivotA: [0, -40],
      localPivotB: [0, 10]
    )
    @kneeJoint1.setLimits(-Math.PI / 8, Math.PI / 8);
    @addConstraint(@kneeJoint1)

    @kneeJoint2 = new p2.RevoluteConstraint(@foot2, @torso,
      localPivotA: [0, -40],
      localPivotB: [0, 10]
    )
    @kneeJoint2.setLimits(-Math.PI / 8, Math.PI / 8);
    @addConstraint(@kneeJoint2)

    @elbowJoint1 = new p2.RevoluteConstraint(@hand1, @torso,
      localPivotA: [0, -23],
      localPivotB: [0, 0]
    )
    @addConstraint(@elbowJoint1)

    @elbowJoint2 = new p2.RevoluteConstraint(@hand2, @torso,
      localPivotA: [0, -23],
      localPivotB: [0, -5]
    )
    @addConstraint(@elbowJoint2)

    @footAnim = 0
    # @setVisualization(Vis)
    return

  addBox: (options) ->
    options.group = options.group || collision.CHARACTER
    options.mask = options.mask || collision.GROUND
    super(options)

  addCircle: (options) ->
    options.group = options.group || collision.CHARACTER
    options.mask = options.mask || collision.GROUND
    super(options)

  update: (dT) ->
    pads = navigator.getGamepads()
    if pads
      @footAnim += dT * pads[0].axes[0] * 15
      if pads[0].buttons[1].value == 1 and @wait < 0
        @torso.applyImpulseLocal(p2.vec2.fromValues(pads[0].axes[0] * 1500,-4500),p2.vec2.fromValues(0,0))
        @torso.velocity[1] = -5000
        @wait = 0.5
      @wait -= dT
    anim = @footAnim

    desiredX = @x
    desiredY = 640

    kt = 100
    cy = Math.sin(@torso.angle)
    cl = 50
    kt = 3000 * Math.abs(cy) * 30
    @torso.applyForceLocal(p2.vec2.fromValues(-cy * kt, 0), p2.vec2.fromValues(0, -cl))

    k1 = Math.cos(anim + 1.5) * 0.4
    @kneeJoint1.pivotB[1] = Math.cos(anim) * 10 + 5
    @kneeJoint1.setLimits(k1, k1)

    k2 = Math.cos(anim + 1.5 + Math.PI) * 0.4
    @kneeJoint2.pivotB[1] = Math.cos(anim + Math.PI) * 10 + 5
    @kneeJoint2.setLimits(k2, k2)

    e1 = Math.cos(anim + 1.4 + Math.PI / 3) * 1.3
    @elbowJoint1.setLimits(e1, e1)

    e2 = Math.cos(anim - 1.8 + Math.PI / 3) * 1.3
    @elbowJoint2.setLimits(e2, e2)

module.exports = Character