
# Players
App.Player = DS.Model.extend
  name:   DS.attr 'string'
  total: (->
    scores = @get('scores')
    total = 0
    scores.forEach (score)=>
      total = total + score.get('points')
    return total
  ).property('scores.@each.points')
  scores: DS.hasMany 'score'

App.Player.FIXTURES = []

# Scores
App.Score = DS.Model.extend
  points: (->
    # Points will be determined by ScoreType.type
    # and Score.count
    count = @get('count')
    type = @get('score_type').get('type')
    scoreHelper = App.ScoreHelper.create
      count: count
      type: type
    return scoreHelper.result
  ).property('count')
  count:      DS.attr 'number'
  player:     DS.belongsTo 'player'
  score_type: DS.belongsTo 'score_type'

App.Score.FIXTURES = []

# ScoreTypes
App.ScoreType = DS.Model.extend
  type:    DS.attr 'string'
  scores:  DS.hasMany 'score'
  default: DS.attr 'number'

App.ScoreType.FIXTURES = [
  { id: 1,  type: 'fields'     , default: 0   }
  { id: 2,  type: 'pastures'   , default: 0   }
  { id: 3,  type: 'grain'      , default: 0   }
  { id: 4,  type: 'vegetables' , default: 0   }
  { id: 5,  type: 'sheep'      , default: 0   }
  { id: 6,  type: 'boar'       , default: 0   }
  { id: 7,  type: 'cattle'     , default: 0   }
  { id: 8,  type: 'unused'     , default: 13  }
  { id: 9,  type: 'fenced'     , default: 0   }
  { id: 10, type: 'clayhut'    , default: 0   }
  { id: 11, type: 'stonehut'   , default: 0   }
  { id: 12, type: 'family'     , default: 2   }
]


# TODO: Move to /helpers
App.ScoreHelper = Ember.Object.extend
  results: 0

  init: ()->
    @_super()
    @set 'result', @_calculate()

  # Here comes fun: http://goo.gl/z9YjIp
  # Ordered ranges, index translates to points:
  # m[0] => -1, m[1] => 1, m[2] => 2, m[3] => 3, m[4] => 4
  metaMetric: [ -1, 1, 2, 3, 4]
  fieldsMetric:
    [ [0,1], [2,2], [3,3], [4,4], [5,Infinity] ]
  pasturesMetric:
    [ [0,0], [1,1], [2,2], [3,3], [4,Infinity] ]
  grainMetric:
    [ [0,0], [1,3], [4,5], [6,7], [5,Infinity] ]
  vegetablesMetric:
    [ [0,0], [1,1], [2,2], [3,3], [4,Infinity] ]
  sheepMetric:
    [ [0,0], [1,3], [4,5], [6,7], [5,Infinity] ]
  boarMetric:
    [ [0,0], [1,2], [3,4], [5,6], [7,Infinity] ]
  cattleMetric:
    [ [0,0], [1,1], [2,3], [4,5], [6,Infinity] ]
  unusedMultiplier: -1
  fencedMultiplier: 1
  clayhutMultiplier: 1
  stonehutMultiplier: 2
  familyMultiplier: 3

  _calculate: ->
    if @[@type + 'Metric']?
      return @_metricCalc()
    else if @[@type + 'Multiplier']?
      return @_multiplierCalc()

  _metricCalc: ->
    result = 0
    count = @get 'count'
    @[@get('type') + 'Metric'].some (range, index)=>
      if count >= range[0] and count <= range[1]
        result = @metaMetric[index]
        return true
      else
        return false
    return result

  _multiplierCalc: ->
    result = @get('count') * @[@get('type') + 'Multiplier']
    return result

