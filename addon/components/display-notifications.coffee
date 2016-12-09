`import Ember from 'ember'`
`import layout from '../templates/components/display-notifications'`

DisplayNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-notifications']
  store: Ember.inject.service()
  refresher: Ember.inject.service("refresher-tool")
  enums: Ember.inject.service("enums-utils")

  idbutton: "showNotifications"
  loading: Ember.computed 'refresher.sourceNotifications', 'refresher.targetNotifications', ->
    if @get('refresher.sourceNotifications') and @get('refresher.targetNotifications') then return false
    else return true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view notifications"

  isDisplayed: false
  buttonTabIndex: "-1"

  display: "source"

  sourceNotifications: Ember.computed.alias 'refresher.sourceNotifications'
  targetNotifications: Ember.computed.alias 'refresher.targetNotifications'

  userObserver: Ember.observer('user.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    @set('refresher.user', @get('user'))

  fetchAssignment: (notification, user) ->
    ret = undefined
    notification.get('assignments').forEach (assignment) ->
      if user.get('id') is assignment.get('assignedTo.id')
        ret = assignment
        return ret
    return ret

  actions:
    toDisplay: (display) ->
      @set 'display', display
    toggleDisplay: ->
      @toggleProperty('isDisplayed')
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
)

`export default DisplayNotificationsComponent`
