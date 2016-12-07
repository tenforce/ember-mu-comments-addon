`import Ember from 'ember'`
`import layout from '../templates/components/display-notifications'`

DisplayNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-notifications']
  store: Ember.inject.service()
  refresher: Ember.inject.service("refresher-tool")

  idbutton: "showNotifications"
  loading: Ember.computed 'refresher.sourceNotifications', 'refresher.targetNotifications', ->
    if @get('refresher.sourceNotifications') and @get('refresher.targetNotifications') then return false
    else return true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view comments"

  isDisplayed: false
  sourceNotifications: undefined
  targetNotifications: undefined
  combinedLength: Ember.computed 'sourceNotifications.length', 'targetNotifications.length', ->
    @get('sourceNotifications.length') + @get('targetNotifications.length')
  buttonTabIndex: "-1"

  display: "source"
  displayNotifications: Ember.computed 'display', 'sourceNotifications', 'targetNotifications', ->
    if 'source' is @get('display') then @get('sourceNotifications')
    else if 'target' is @get('display') then @get('targetNotifications')
    else []

  sourceNotifications: Ember.computed.alias 'refresher.sourceNotifications'
  targetNotifications: Ember.computed.alias 'refresher.targetNotifications'

  userObserver: Ember.observer('user.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    @set('refresher.user', @get('user'))


  actions:
    toDisplay: (display) ->
      @set 'display', display
    toggleDisplay: ->
      @toggleProperty('isDisplayed')

)

`export default DisplayNotificationsComponent`
