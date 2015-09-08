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