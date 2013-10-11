App.EditScoreView = Ember.TextField.extend
  didInsertElement: ->
    this.$().focus()

Ember.Handlebars.helper('edit-score', App.EditScoreView)