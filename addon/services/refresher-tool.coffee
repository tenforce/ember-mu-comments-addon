`import Ember from 'ember'`

RefresherToolService = Ember.Service.extend
  store: Ember.inject.service()
  about: undefined
  user: undefined
  refreshingComments: true
  refreshingNotifications: true

  aboutObserver: Ember.observer('about.id', () ->
    @refreshComments()
  ).on('init')

  userObserver: Ember.observer('user.id', () ->
    @refreshNotifications()
  ).on('init')

  refreshComments: (schedule) ->
    @set('refreshingComments', true)
    promises = []
    promises.push(@getUsers())
    promises.push(@getComments())
    ret = Ember.RSVP.Promise.all(promises).then =>
      @set('refreshingComments', false)
    if schedule
      Ember.run.later(@refreshComments, 60000)
    ret
  refreshNotifications: (schedule) ->
    @set('refreshingNotifications', true)
    promises = []
    promises.push(@getSourceNotifications())
    promises.push(@getTargetNotifications())
    ret = Ember.RSVP.Promise.all(promises).then =>
      @set('refreshingNotifications', false)
    if schedule
      Ember.run.later(@refreshNotifications, 60000)
    ret

  getUsers: () ->
    @get('store').query('user', {}).then (users) =>
      @set 'users', users

  getComments: () -> (
    @get('store').query('comment',
      filter:
          about:
            id: @get('about.id')
      include: "notifications.assigned-to,notifications.created-by"
    )
    .then (result) =>
      @set 'comments', result
  )

  getSourceNotifications: () ->
    @get('store').query('comment-notification',
      filter:
        "created-by":
          id: @get('user.id')
    )
    .then (result) =>
      @set 'sourceNotifications', result
  getTargetNotifications: () ->
    @get('store').query('comment-notification',
      filter:
        "assigned-to":
          id: @get('user.id')
    )
    .then (result) =>
      @set 'targetNotifications', result

`export default RefresherToolService`
