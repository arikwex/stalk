class Renderer
  constructor: ->
    @visualizations = {}
    return

  register: (visualization) ->
    if not visualization.id
      visualization.id = (Math.random()).toString(16).substr(2)
    @visualizations[visualization.id] = visualization
    return

  render: (entity) ->
    entity.visualization.render(entity)
    return

module.exports = new Renderer()