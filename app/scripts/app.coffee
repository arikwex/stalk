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

  window.engine = engine
  window.pixi = require('pixi')
  window.p2 = require('p2')
  window.character = currentMap.getPlayer()
)