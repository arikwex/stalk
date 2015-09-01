$ = require('jquery');
Engine = require('./engine/Engine')

$(->
  engine = new Engine(1024, 768)
  engine.attach(document.body)
  engine.start()

  window.engine = engine
)