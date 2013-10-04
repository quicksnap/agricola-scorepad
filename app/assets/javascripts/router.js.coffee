# For more information see: http://emberjs.com/guides/routing/

App.Router.map ()->
  @resource( 'scorepad', { path: '/' } )

App.ScorepadRoute = Ember.Route.extend
  model: ->
    @get('store').find 'player'
