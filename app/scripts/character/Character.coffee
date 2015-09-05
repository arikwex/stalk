Entity = require('engine/Entity')
Vis = require('./visualization')
collision = require('enum/collision')
p2 = require('p2')
material = require('enum/material')

POSES =
  IDLE: 'idle'
  WALK: 'walk'
  SNEAK: 'sneak'
  JUMP: 'jump'
  COLLECT: 'collect'
  PLAYDEAD: 'playdead'

class Character extends Entity
  constructor: (options) ->
    super()
    { @x
      @y } = options
    @powered = true
    @pose = POSES.IDLE
    @anim = 0
    @moveSpeed = 0

    @head = @addCircle(
      radius: 18
      position: [@x, @y - 50]
      mass: 1
    )
    @torso = @addCircle(
      radius: 20
      position: [@x, @y]
      mass: 1.5
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
    # pads = null#navigator.getGamepads()
    # if pads
    #   @footAnim += dT * pads[1].axes[0] * 15
    #   if pads[1].buttons[1].value == 1 and @wait < 0
    #     @torso.applyImpulseLocal(p2.vec2.fromValues(pads[1].axes[0] * 1500,-4500),p2.vec2.fromValues(0,0))
    #     @torso.velocity[1] = -5000
    #     @wait = 0.5
    #   @wait -= dT
    if @pose == POSES.WALK or @pose == POSES.SNEAK
      @anim += dT * @moveSpeed * 15
    else
      @anim += dT * 4
    anim = @anim

    if @powered
      kt = 100
      cy = Math.sin(@torso.angle)
      cl = 50
      kt = 3000 * Math.abs(cy) * 30
      @torso.applyForceLocal(p2.vec2.fromValues(-cy * kt, 0), p2.vec2.fromValues(0, -cl))

      if @pose == POSES.IDLE
        k1 = 0.3
        @kneeJoint1.pivotB[1] = 5 + Math.cos(anim + 0.15) * 5
        @kneeJoint1.setLimits(k1, k1)
        k2 = -0.3
        @kneeJoint2.pivotB[1] = 5 + Math.cos(anim) * 5
        @kneeJoint2.setLimits(k2, k2)
        e1 = Math.cos(anim) * 0.2 - 0.6
        @elbowJoint1.setLimits(e1, e1)
        e2 = Math.cos(anim + Math.PI) * 0.2 + 0.6
        @elbowJoint2.setLimits(e2, e2)
      else if @pose == POSES.WALK
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
      else if @pose == POSES.SNEAK
        k1 = Math.cos(anim + 1.5) * 0.3
        @kneeJoint1.pivotB[1] = Math.cos(anim) * 10 + 5
        @kneeJoint1.setLimits(k1, k1)
        k2 = Math.cos(anim + 1.5 + Math.PI) * 0.3
        @kneeJoint2.pivotB[1] = Math.cos(anim + Math.PI) * 10 + 5
        @kneeJoint2.setLimits(k2, k2)
        e1 = Math.cos(anim + 1.4 + Math.PI / 3) * 0.1 + (if @moveSpeed > 0 then 1.4 else -1.4)
        @elbowJoint1.setLimits(e1, e1)
        e2 = Math.cos(anim - 1.8 + Math.PI / 3) * 0.1 + (if @moveSpeed > 0 then 1.6 else -1.6)
        @elbowJoint2.setLimits(e2, e2)
    else
      @kneeJoint1.setLimits(-Math.PI / 2, Math.PI / 2)
      @kneeJoint2.setLimits(-Math.PI / 2, Math.PI / 2)
      @elbowJoint1.setLimits(-Math.PI, Math.PI)
      @elbowJoint2.setLimits(-Math.PI, Math.PI)

  idle: ->
    @pose = POSES.IDLE
    @moveSpeed = 0
    return

  move: (speed) ->
    @moveSpeed = speed
    if Math.abs(@moveSpeed) > 0.4
      @pose = POSES.WALK
    else
      @pose = POSES.SNEAK

  togglePlaydead: ->
    @powered = !@powered

module.exports = Character