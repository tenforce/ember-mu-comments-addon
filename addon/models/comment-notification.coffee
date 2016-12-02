`import DS from 'ember-data'`

CommentNotification = DS.Model.extend {
  createdBy: DS.belongsTo('user')
  createdWhen: DS.attr('date')
  solved: DS.attr()
  solvedBy: DS.belongsTo('user')
  solvedWhen: DS.attr('date')
  comment: DS.belongsTo('comment')
  status: DS.attr('string')
  assignedTo: DS.belongsTo('user')


  setSolve: (who, time, bool) ->
    @set('solved', bool)
    @set('solvedBy', who)
    @set('solvedWhen', time)
    @set('status', @get('statusShow'))
    @save()
  solve: (who, time) ->
    @setSolve(who, time, true)
  unsolve: (who, time) ->
    @setSolve(who, time, false)

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  lastModifier: DS.belongsTo('user', inverse: null, async: false )
  lastModified: DS.attr('string')
  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
    @_super(arguments...)
}

`export default CommentNotification`
