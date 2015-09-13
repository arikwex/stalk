module.exports =
  render: (entity) ->
    for body in entity.bodies
      gfx = body.graphics
      gfx.clear()
      gfx.lineStyle(1, 0xffffff, 1)
      shape = body.shapes[0]
      if shape.width
        w = shape.width
        h = shape.height
        gfx.moveTo(-w / 2.0, -h / 2.0)
        gfx.lineTo(w / 2.0, -h / 2.0)
        gfx.lineTo(w / 2.0, h / 2.0)
        gfx.lineTo(-w / 2.0, h / 2.0)
      else if shape.radius
        r = shape.radius
        gfx.drawCircle(0, 0, r)
        gfx.moveTo(0, 0)
        gfx.lineTo(r, 0)
      gfx.position.x = body.position[0]
      gfx.position.y = body.position[1]
      gfx.rotation = body.angle
    return