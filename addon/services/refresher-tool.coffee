`import Ember from 'ember'`

RefresherToolService = Ember.Service.extend
  store: Ember.inject.service()
  about: undefined
  user: undefined
  refreshingComments: true
  refreshingNotifications: true

  refreshTimer: 60000

  # we need to refresh comments when the concept has changed
  aboutObserver: Ember.observer('about.id', () ->
    if @get('about.id') then @refreshComments()
  ).on('init')

  # we need to refresh the notifications when the user has changed (which shouldn't happen but hey)
  userObserver: Ember.observer('user.id', () ->
    if @get('user.id') then @refreshNotifications()
  ).on('init')

  # refresh comments then poll again in x milliseconds
  refreshComments: () ->
    timer = @get('refreshTimer')
    @set('refreshingComments', true)
    promises = []
    promises.push(@getUsers())
    promises.push(@getComments())
    Ember.RSVP.Promise.all(promises).then =>
      @set('refreshingComments', false)
      Ember.run.debounce(@, @refreshComments, timer)

  # refresh notifications then poll again in x milliseconds
  refreshNotifications: () ->
    timer = @get('refreshTimer')
    @set('refreshingNotifications', true)
    promises = []
    promises.push(@getSourceNotifications())
    promises.push(@getTargetNotifications())
    Ember.RSVP.Promise.all(promises).then =>
      @set('refreshingNotifications', false)
      Ember.run.debounce(@, @refreshNotifications, timer)

  getUsers: () ->
    @get('store').query('user', {}).then (users) =>
      @set 'users', users

  getComments: () -> (
    @get('store').query('comment',
      filter:
          about:
            id: @get('about.id')
      include: "notification.assignments.assigned-to,notification.created-by"
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
      @set 'unfilteredSourceNotifications', result
  getTargetNotifications: () ->
    @get('store').query('notification-assignment',
      filter:
        "assigned-to":
          id: @get('user.id')
    )
    .then (result) =>
      @set 'unfilteredTargetNotifications', result

  combinedLength: Ember.computed 'filteredSourceNotifications.length', 'filteredTargetNotifications.length', ->
    @get('filteredSourceNotifications.length') + @get('filteredTargetNotifications.length')

  # this bool can be modified from anything using the service
  shouldFilterNotificationsOnStatus: true

  # in order to be able to count the notifications that are not hidden, we need to keep the original array + a computed one
  filteredSourceNotifications: Ember.computed 'unfilteredSourceNotifications', 'unfilteredSourceNotifications.@each.status', ->
    @get('unfilteredSourceNotifications')?.filter (notification) ->
      if notification.get('status') is "hide" then return false
      else return true
  filteredTargetNotifications: Ember.computed 'unfilteredTargetNotifications', 'unfilteredTargetNotifications.@each.status', ->
    @get('unfilteredTargetNotifications')?.filter (notification) ->
      if notification.get('status') is "hide" then return false
      else return true


`export default RefresherToolService`
