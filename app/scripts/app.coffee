$ = require('jquery');
Engine = require('./engine/Engine')
Character = require('./character/Character')

$(->
  engine = new Engine(1024, 768)
  engine.attach(document.body)
  engine.start()

  character = new Character(
    x: 100
    y: 400
  )
  engine.addEntity(character)

  window.engine = engine
  window.pixi = require('pixi')
  window.p2 = require('p2')
  window.character = character
)