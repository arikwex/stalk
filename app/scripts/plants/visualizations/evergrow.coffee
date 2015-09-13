module.exports =
  render: (plant) ->
    body = plant.bodies[0]
    gfx = body.graphics
    gfx.clear()
    gfx.lineStyle(4, 0xffffff)
    gfx.moveTo(plant.x, plant.y)
    for i in [0..10]
      q = i * 0.6 + (+new Date() / 900.0)
      dx1 = Math.cos(q) * 0.5 * i
      dy1 = -i * 6
      q2 = (i+1) * 0.6 + (+new Date() / 900.0)
      dx2 = Math.cos(q2) * 0.5 * (i+1)
      dy2 = -(i+1) * 6
      gfx.moveTo(dx1, dy1)
      gfx.lineTo(dx2, dy2)

      q = i * 0.8 + (+new Date() / 700.0)
      dx1 = Math.cos(q) * 0.5 * i + i * 0.4
      dy1 = -i * 3
      q2 = (i+1) * 0.8 + (+new Date() / 700.0)
      dx2 = Math.cos(q2) * 0.5 * (i+1) + (i+1) * 0.4
      dy2 = -(i+1) * 3
      gfx.moveTo(dx1 + 8, dy1)
      gfx.lineTo(dx2 + 8, dy2)

      q = i * 0.7 + (+new Date() / 800.0)
      dx1 = Math.cos(q) * 0.4 * i - i * 0.4
      dy1 = -i * 4.5
      q2 = (i+1) * 0.7 + (+new Date() / 800.0)
      dx2 = Math.cos(q2) * 0.4 * (i+1) - (i+1) * 0.4
      dy2 = -(i+1) * 4.5
      gfx.moveTo(dx1 - 8, dy1)
      gfx.lineTo(dx2 - 8, dy2)

    gfx.position.x = body.position[0]
    gfx.position.y = body.position[1]
    gfx.rotation = body.angle
    return