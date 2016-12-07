`import Ember from 'ember';`
`import layout from '../templates/components/display-comment';`
`import SearchUtils from '../mixins/search-utils'`

DisplayComment = Ember.Component.extend SearchUtils,
  layout: layout
  classNames:['display-comment']
  classNameBindings: ['comment.status', 'editing:editMode']
  enums: Ember.inject.service("enums-utils")
  store: Ember.inject.service()

  author: Ember.computed.alias 'comment.author'
  authorName: Ember.computed 'author', ->
    @get('author').then (author) ->
      return author.get('name') || "anonymous"
  editing: false
  loading: false
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  isSolved: Ember.computed 'comment.status', 'enums.status.solved', ->
    return @get('comment.status') is @get('enums.status.solved')

  allowModification: Ember.computed 'user', 'author', ->
    if @get('user.id') is @get('author.id') then return true
    else return false
  disable: Ember.computed.or 'allowedModification', 'loading'

  ensureAssigned: (date) ->
    promises = []
    comment = @get('comment')
    assignedUsers = @get('assignedUsers')
    comment.get('notifications').forEach (notification) =>
      promises.push(notification.destroyRecord())
    Ember.RSVP.Promise.all(promises).then =>
      unless date then date = new Date().toISOString()
      assignedUsers.forEach (user) =>
        assignment = @get('store').createRecord('comment-notification')
        assignment.set('createdBy', comment.get('author'))
        assignment.set('createdWhen', date)
        assignment.set('solved', "false")
        assignment.set('comment', comment)
        assignment.set('status', @get('enums.status.show'))
        assignment.set('assignedTo', user)
        assignment.save().then (persistedNotification) =>
          comment.get('notifications').pushObject(persistedNotification)

  handleEnter: ->
    @finishEditing()
  finishEditing: ->
    @set('loading', true)
    @set('editing', false)
    date = new Date().toISOString()
    @set('comment.modificationDate', date)
    @get('comment').save().then =>
      @ensureAssigned(date).then =>
        unless @get('isDestroyed') then @set 'loading', false
    return @get('comment')

  finishChangeStatus: ->
    unless(this.get('disable'))
      if(this.get('comment.status') is @get('enums.status.unsolved')) then this.set('comment.status', @get('enums.status.solved'))
      else if(this.get('comment.status') is @get('enums.status.solved')) then this.set('comment.status', @get('enums.status.unsolved'))
      @set('loading', true)
      @set('editing', false)
      promises = []
      user = @get('user')
      status = @get('comment.status')
      @get('comment.notifications').then (notifications) =>
        notifications.forEach (notification) =>
          if status is @get('enums.status.solved')
            promises.push(notification.solve(user, new Date().toISOString()))
          else if status is @get('enums.status.unsolved')
            promises.push(notification.unsolve(user, new Date().toISOString()))
      promises.push(@get('comment').save())
      Ember.RSVP.Promise.all(promises).then =>
        unless @get('isDestroyed') then @set 'loading', false
      return @get('comment')

  shouldDisableTextArea: Ember.computed 'editing', 'disableComment', ->
    if not @get('editing') or @get('disableComment') then return true

  assignedUsersSetter: Ember.observer('comment.id', () ->
    promises = []
    @get('comment.notifications').forEach (notification) ->
      promises.push(notification.get('assignedTo'))
    users = []
    Ember.RSVP.Promise.all(promises).then (assigned) =>
      assigned.forEach (user) ->
        unless users.contains(user) then users.push(user)
      @set('assignedUsers', users)
  ).on('init')
  assignedUsers: undefined

  actions:
    deleteComment: (comment) ->
      comment?.destroyRecord().then =>
        @sendAction('refresh')

    toggleEditing: () ->
      if @get('editing') then @finishEditing()
      else
        @toggleProperty('editing')

    changeStatus: ->
      @finishChangeStatus()

`export default DisplayComment;`
