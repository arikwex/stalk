Entity = require('engine/Entity')
collision = require('enum/collision')
material = require('enum/material')

class Terrain extends Entity
  constructor: (info) ->
    super()
    if info.polygon
      return # TODO: build from polygon info
    @_buildRectangle(info)
    return

  _buildRectangle: (info) ->
    rectInfo =
      position: [info.x, info.y]
      width: info.width
      height: info.height
      group: collision.GROUND
      mask: collision.GROUND | collision.CHARACTER
      mass: info.width * info.height * 0.01
      material: material.GROUND
      fixedX: (if info.fixedX? then info.fixedX else true)
      fixedY: (if info.fixedX? then info.fixedX else true)
      fixedRotation: (if info.fixedRotation? then info.fixedRotation else true)
    @body = @addBox(rectInfo)
    return

module.exports = Terrain