`import Ember from 'ember';`
`import layout from '../templates/components/display-comment';`
`import SearchUtils from '../mixins/search-utils'`

DisplayComment = Ember.Component.extend SearchUtils,
  layout: layout
  classNames: ['comment']
  classNameBindings: ['comment.status', 'editing:editMode']
  enums: Ember.inject.service("enums-utils")
  dateFormat: Ember.inject.service("date-format")
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
  disable: Ember.computed 'allowModification', 'loading', ->
    if @get('loading') then return true
    else unless @get('allowModification') then return true
    return false
  disableCheckbox: Ember.computed 'loading', 'comment.notification.assignments.@each.assignedTo', ->
    if @get('loading') then return true
    else
      ret = true
      @get('comment.notification.assignments')?.forEach (assignment) =>
        if @get('user.id') is assignment.get('assignedTo.id')
          ret = false
          return ret
      ret

  # used to make sure we have a notification to use
  ensureNotification: (date) ->
    @get('comment.notification').then (notification) =>
      if notification
        notification.set('comment', @get('comment'))
        notification.set('createdBy', @get('user'))
        notification.set('createdWhen', date)
        notification.set('status', @get('enums.status.show'))
        return notification
      else
        notification =  @get('store').createRecord('comment-notification')
        notification.set('comment', @get('comment'))
        notification.set('createdBy', @get('user'))
        notification.set('createdWhen', date)
        notification.set('status', @get('enums.status.show'))
        return notification

  # this will remove and then regenerate assignments / notification if needed
  ensureAssigned: (date) ->
    unless date then date = new Date().toISOString()
    promises = []
    comment = @get('comment')
    assignedUsers = @get('assignedUsers')
    @ensureNotification(date).then (notification) =>
      notification.get('assignments')?.forEach (assignment) =>
        # first we delete the existing assignments
        promises.push(assignment.destroyRecord())
      Ember.RSVP.Promise.all(promises).then =>
        # if we don't have anyone to warn, there's no point in having a notification
        if assignedUsers.get('length') is 0
            notification?.destroyRecord()
        else
          # otherwise, we first need to save the notification then we can create assignments as they will need the notification-uuid
          notification.save().then (notif) =>
            comment.set('notification', notif)
            assignedUsers.forEach (user) =>
              assignment = @get('store').createRecord('notification-assignment')
              assignment.set('notification', notif)
              assignment.set('status', @get('enums.status.show'))
              assignment.set('assignedTo', user)
              assignment.save().then (persistedAssignment) =>
                comment.get('notification.assignments')?.pushObject(persistedAssignment)

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
    unless(@get('disableCheckbox'))
      if(@get('comment.status') is @get('enums.status.unsolved')) then @set('comment.status', @get('enums.status.solved'))
      else if(@get('comment.status') is @get('enums.status.solved')) then @set('comment.status', @get('enums.status.unsolved'))
      @set('loading', true)
      @set('editing', false)
      promises = []
      user = @get('user')
      status = @get('comment.status')
      date = new Date().toISOString()
      @get('comment.notification').then (notification) =>
          # first we need to change change the solved status of the notification
          if status is @get('enums.status.solved')
            promises.push(notification.solve(user, date))
          else if status is @get('enums.status.unsolved')
            promises.push(notification.unsolve(user, date))
          # then we iterate through all assignments and reset their status to "show"
          notification.get('assignments').forEach (assignment) =>
            assignment.set('status', @get('enums.status.show')
            promises.push(assignment.save()))

      promises.push(@get('comment').save())
      Ember.RSVP.Promise.all(promises).then =>
        unless @get('isDestroyed') then @set 'loading', false
      return @get('comment')

  # we should disable the textarea when we're editing or when we're searching for a user
  shouldDisableTextArea: Ember.computed 'editing', 'disableComment', ->
    if not @get('editing') or @get('disableComment') then return true

  # fetching the list of already assigned users on startup
  assignedUsersSetter: Ember.observer('comment.id', () ->
    promises = []
    unless @get('comment.notification.assignments') then @set('assignedUsers', [])
    else
      @get('comment.notification.assignments').forEach (notification) ->
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
