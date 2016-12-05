`import Ember from 'ember'`
`import layout from '../templates/components/display-notifications'`

DisplayNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-notifications']
  store: Ember.inject.service()

  idbutton: "showNotifications"
  loading: true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view comments"

  userObserver: Ember.observer('user.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    promises = []
    promises.push @getSourceNotifications()
    promises.push @getTargetNotifications()
    Ember.RSVP.Promise.all(promises).then =>
      @set 'loading', false
  fetchNotifications: () ->
    promises = []
    promises.push @getSourceNotifications()
    promises.push @getTargetNotifications()
    Ember.RSVP.Promise.all(promises)

  isDisplayed: false
  sourceNotifications: undefined
  targetNotifications: undefined
  combinedLength: Ember.computed 'sourceNotifications.length', 'targetNotifications.length', ->
    @get('sourceNotifications.length') + @get('targetNotifications.length')
  buttonTabIndex: "-1"


  getSourceNotifications: () ->
    @get('store').query('comment-notification',
      filter:
        {
          "created-by":
            id: @get('user.id')
        }
    )
    .then (result) =>
      @set 'sourceNotifications', result
  getTargetNotifications: () ->
    @get('store').query('comment-notification',
      filter:
        {
          "assigned-to":
            id: @get('user.id')
        }
    )
    .then (result) =>
      @set 'targetNotifications', result
  display: "source"
  displayNotifications: Ember.computed 'display', 'sourceNotifications', 'targetNotifications', ->
    if 'source' is @get('display') then @get('sourceNotifications')
    else if 'target' is @get('display') then @get('targetNotifications')
    else []

  actions:
    toDisplay: (display) ->
      @set 'display', display
    toggleDisplay: ->
      @toggleProperty('isDisplayed')

)

`export default DisplayNotificationsComponent`
