`import Ember from 'ember'`
`import layout from '../templates/components/display-comments'`

DisplayCommentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-comments']
  store: Ember.inject.service()
  intl: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")

  init: ->
    @get('intl').setLocale('en-us')
    this._super()

  aboutObserver: Ember.observer('about.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    promises = []
    promises.push @getComments()
    promises.push @getUsers()
    Ember.RSVP.Promise.all(promises).then =>
      @set 'loading', false

  isDisplayed: false
  comments: undefined
  buttonTabIndex: "-1"


  getUsers: () ->
    @get('store').query('user', {}).then (users) =>
      @set 'users', users

  getComments: () -> (
    @get('store').query('comment',
      filter:
        {
          about:
            id: @get('about.id')
        }
      include: "notifications"
    )
    .then (result) =>
      @set 'comments', result
  )

  idbutton: "showComments"
  loading: true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view comments"

  actions:
    toggleDisplay: ->
      @toggleProperty('isDisplayed')

    createComment: (comment, assigned) ->
      comment.save().then (persistedComment) =>
        assigned?.forEach (toNotify) =>
          assignment = @get('store').createRecord('comment-notification')
          assignment.set('createdBy', persistedComment.get('author'))
          assignment.set('createdWhen', new Date().toISOString())
          assignment.set('solved', "false")
          assignment.set('comment', persistedComment)
          assignment.set('status', @get('enums.status.show'))
          assignment.set('assignedTo', toNotify)
          assignment.save().then (persistedNotification) =>
            persistedComment.get('notifications').pushObject(persistedNotification)
        @getComments()
      return

    deleteComment: (comment) ->
      comment?.destroyRecord().then  =>
        @getComments()
      return

)

`export default DisplayCommentsComponent`
