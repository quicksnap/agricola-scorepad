
# Players
App.Player = DS.Model.extend
  name:   DS.attr 'string'
  scores: DS.hasMany 'score'

App.Player.FIXTURES = []

# Scores
App.Score = DS.Model.extend
  points:     DS.attr 'string'
  player:     DS.belongsTo 'player'
  score_type: DS.belongsTo 'score_type'

App.Score.FIXTURES = []

# ScoreTypes
App.ScoreType = DS.Model.extend
  type:   DS.attr 'string'
  scores: DS.hasMany 'score'

App.ScoreType.FIXTURES = [
  {
    id:   1
    type: 'fields'
  }
  {
    id:   2
    type: 'pastures'
  }
  {
    id:   3
    type: 'family'
  }
]
