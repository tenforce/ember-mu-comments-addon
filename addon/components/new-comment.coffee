`import Ember from 'ember';`
`import layout from '../templates/components/new-comment';`
`import SearchUtils from '../mixins/search-utils'`

NewComment = Ember.Component.extend SearchUtils,
  layout: layout
  store: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")
  language: Ember.computed -> @get('user.language') || "en"
  languageObserver: Ember.observer('language', 'comment',  () ->
    @set('comment.messageLanguage', @get('language'))
    @set('comment.language', @get('language'))
  ).on('init')

  init: ->
    @_super()
    @newComment()
  didInsertElement: ->
    Ember.run.next =>
      @$('textarea')?[0]?.focus()
  newComment: ->
    @set('assignedUsers', [])
    @set('searchString', '')
    @set('comment', @get('store').createRecord('comment'))
    @ensureNotification(false)
  ensureNotification: (save) ->
    @set('notification', @get('store').createRecord('comment-notification'))
    @set('notification.assignments', [])
    if (save) then @get('notification.save')

  textAreaPlaceholder: "Please enter your comment"
  addButtonLabel: "Comment"
  comment: undefined
  showModal: true


  handleEnter: ->
    @creatingComment()

  # very long function to just create a comment and notification and assignments and stuff
  creatingComment:  ->
    date = new Date().toISOString()
    comment = @get('comment')
    unless comment.get('language') then comment.set('language', @get('language'))
    comment.set('status', @get('enums.status.unsolved'))
    comment.set('creationDate', date)
    comment.set('author', @get('user'))
    comment.set('about', @get('about'))
    assigned = @get('assignedUsers')
    comment.save().then (persistedComment) =>
      if assigned?.length > 0
        notification = @get('notification')
        notification?.set('comment', persistedComment)
        notification?.set('createdBy', @get('user'))
        notification?.set('createdWhen', date)
        notification?.set('status', @get('enums.status.show'))
        notification?.set('assignments', [])
        notification.save().then (persistedNotification) =>
          persistedComment.set('notification', persistedNotification)
          assigned?.forEach (toNotify) =>
            assignment = @get('store').createRecord('notification-assignment')
            assignment.set('notification', persistedNotification)
            assignment.set('status', @get('enums.status.show'))
            assignment.set('assignedTo', toNotify)
            assignment.save().then (persistedAssignment) =>
              persistedComment.get('notification.assignments').pushObject(persistedAssignment)
        @newComment()
        @sendAction('refresh')
      else
        @newComment()
        @sendAction('refresh')


`export default NewComment;`
