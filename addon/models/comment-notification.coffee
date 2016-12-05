`import DS from 'ember-data'`

CommentNotification = DS.Model.extend {
  enums: Ember.inject.service("enums-utils")

  createdBy: DS.belongsTo('user')
  createdWhen: DS.attr('string')
  solved: DS.attr('string')
  solvedBy: DS.belongsTo('user')
  solvedWhen: DS.attr('string')
  comment: DS.belongsTo('comment')
  status: DS.attr('string')
  assignedTo: DS.belongsTo('user')

  setSolve: (who, time, bool) ->
    @set('solved', bool)
    @set('solvedBy', who)
    @set('solvedWhen', time)
    @set('status', @get('enums.status.show'))
    @save()
  solve: (who, time) ->
    @setSolve(who, time, "true")
  unsolve: (who, time) ->
    @setSolve(who, time, "false")
}

`export default CommentNotification`
