App.ScorepadController = Ember.ArrayController.extend
  winnersInflect: ( ->
    if @get('winners').length > 1 then return 'Winners are' else return 'Winner is'
  ).property('winners')
  winners: ( ->
    topPlayers = []
    topScore   = -14
    @get('model').forEach (player, index)->
      if player.get('total') > topScore
        topScore = player.get('total')
        # replace the entire array with single player
        topPlayers = [player]
      else if player.get('total') == topScore
        topPlayers.push player

    return topPlayers
  ).property('@each.total')
  actions:
    createPlayer: ->
      playerName = @get 'newPlayer'

      if !playerName.trim()
        @set 'newPlayer', ''
        return

      newPlayer = @store.createRecord 'player', {
        name: playerName
      }

      deferred = []

      # Get the predefined set of ScoreTypes
      scoreTypes = @store.find('score_type')
      scoreTypes.then =>
        # For every ScoreType, create a score of that
        # type and assoc. with new Player
        scoreTypes.forEach (scoreType) =>

          score = @store.createRecord 'score', {
            count: scoreType.get('default')
            player: newPlayer
            score_type: scoreType
          }
          # Inverse relationship
          scoreType.get('scores').addObject(score)
          newPlayer.get('scores').addObject(score)
          deferred.push scoreType.save()
          deferred.push score.save()

        # Save everything
        Ember.RSVP.all(deferred).then =>
          # newPlayer.save()

      @set 'newPlayer', ''

App.ScoreController = Ember.ObjectController.extend
  isEditing: false
  validCount: ( (key, value, oldValue) ->
    if (arguments.length == 1)
      return Math.round @get('count')
    else
      # With a type="number" field, invalid input such as '123abc' will get
      # here with empty value. We retain last good number value.
      newValue = String(value || oldValue)

      # Number filter and coerce
      newNumber = Math.round( newValue.split(/[ ]/)[0].replace( /[^\d]/g, '' ) )

      @set('count', newNumber )
      return newNumber
  ).property('count')
  actions:
    editScore: ->
      this.set('isEditing', true)
    acceptChanges: ->
      @set('isEditing', false)
      @get('model').save()

App.PlayerController = Ember.ObjectController.extend
  baz: 'bar'
