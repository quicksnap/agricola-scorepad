App.ScorepadController = Ember.ArrayController.extend
  actions:
    createPlayer: ->
      playerName = @get 'newPlayer'

      if !playerName.trim()
        @set 'newPlayer', ''
        return

      newPlayer = @store.createRecord 'player', {
        name: playerName
      }

      # Get the predefined set of ScoreTypes
      scoreTypes = @store.find('score_type')
      scoreTypes.then =>
        # For every ScoreType, create a score of that
        # type and assoc. with new Player
        scores = []
        scoreTypes.forEach (scoreType) =>
          score = @store.createRecord 'score', {
            points: 0
          }
          score.set('player', newPlayer)
          score.set('score_type', scoreType)
          scores.push score
        # Set up inverse relationships
        scoreTypes.get('scores').pushObjects(scores)
        newPlayer.get('scores').pushObjects(scores)

        deferred = []
        scores.forEach (score) =>
          deferred.push score.save()

        Ember.RSVP.all(deferred).then =>
          newPlayer.save()

      @set 'newPlayer', ''