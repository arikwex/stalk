$ = require('jquery');
Engine = require('./engine/Engine')
GameMap = require('maps/GameMap')
KeyboardController = require('controllers/Keyboard')

$(->
  engine = new Engine(1024, 768)
  engine.attach(document.body)
  engine.start()

  currentMap = new GameMap(engine)
  currentMap.load(require('maps/levels/sandbox'))

  Plant = require('plants/Plant')
  p = new Plant('Evergrow',
    x: 625
    y: 400
    angle: Math.PI/2)
  p.lockToGround(engine.world.bodies)
  engine.addEntity(p)

  controller = new KeyboardController(currentMap.getPlayer())
  controller.onDown(['RIGHT', '!LEFT', 'SHIFT'], 'move', 0.35)
  controller.onDown(['LEFT', '!RIGHT', 'SHIFT'], 'move', -0.35)
  controller.onDown(['RIGHT', '!LEFT', '!SHIFT'], 'move', 1)
  controller.onDown(['LEFT', '!RIGHT', '!SHIFT'], 'move', -1)
  controller.onPress(['W'], 'togglePlaydead')
  controller.onPress(['SPACE'], 'jump')
  controller.onNone('idle')

  collision = require('enum/collision')
  material = require('enum/material')
  Entity = require('engine/Entity')
  for x in [0..8]
    pombi = new Entity()
    fruit = pombi.addCircle(
      radius: 26
      position: [300 - x * 15, 500 - x * 5]
      mass: 2
      material: material.BODY
      group: collision.BODY
      mask: collision.GROUND | collision.BODY | collision.CHARACTER
    )
    PIXI = require('pixi')
    midTexture = PIXI.Texture.fromImage("images/pombi.png");
    mid = new PIXI.Sprite(midTexture);
    mid.position.x = -34;
    mid.position.y = -36;
    fruit.angle = Math.random()*7
    mid.scale =
      x: 0.2
      y: 0.2
    fruit.graphics.addChild(mid);
    fruit.angularDamping = 0.99
    engine.addEntity(pombi)

  window.engine = engine
  window.pixi = require('pixi')
  window.p2 = require('p2')
  window.character = currentMap.getPlayer()
)