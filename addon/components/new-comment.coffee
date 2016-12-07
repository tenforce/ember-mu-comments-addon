`import Ember from 'ember';`
`import layout from '../templates/components/new-comment';`
`import SearchUtils from '../mixins/search-utils'`

NewComment = Ember.Component.extend SearchUtils,
  layout: layout
  classNames:['new-comment']
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

  textAreaPlaceholder: "Please enter your comment"
  addButtonLabel: "Add comment"
  comment: undefined
  showModal: true


  handleEnter: ->
    @creatingComment()
  creatingComment:  ->
    comment = @get('comment')
    unless comment.get('language') then comment.set('language', @get('language'))
    comment.set('status', @get('enums.status.unsolved'))
    comment.set('creationDate', (new Date()).toISOString())
    comment.set('author', @get('user'))
    comment.set('about', @get('about'))
    assigned = @get('assignedUsers')

    comment.save().then (persistedComment) =>
      date = new Date().toISOString()
      assigned?.forEach (toNotify) =>
        assignment = @get('store').createRecord('comment-notification')
        assignment.set('createdBy', persistedComment.get('author'))
        assignment.set('createdWhen', date)
        assignment.set('solved', "false")
        assignment.set('comment', persistedComment)
        assignment.set('status', @get('enums.status.show'))
        assignment.set('assignedTo', toNotify)
        assignment.save().then (persistedNotification) =>
          persistedComment.get('notifications').pushObject(persistedNotification)
      @newComment()
      @sendAction('refresh')


`export default NewComment;`
