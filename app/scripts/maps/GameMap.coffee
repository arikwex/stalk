Entity = require('engine/Entity')
Character = require('character/Character')
Terrain = require('./Terrain')

class GameMap extends Entity
  constructor: (@engine) ->
    @character = null
    return

  load: (layout) ->
    @_loadPlayer(layout.player)
    @_loadTerrain(layout.terrain)
    return

  unload: ->
    return

  getPlayer: -> @character

  _loadPlayer: (playerInfo) ->
    if !playerInfo
      return
    @character = new Character(playerInfo)
    @engine.addEntity(@character)

  _loadTerrain: (terrain) ->
    for element in terrain
      @_loadGrass(element.grass)
    return

  _loadGrass: (grassInfo) ->
    if !grassInfo
      return
    grass = new Terrain(grassInfo)
    @engine.addEntity(grass)
    return

module.exports = GameMap