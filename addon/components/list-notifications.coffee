`import Ember from 'ember'`
`import layout from '../templates/components/list-notifications'`

ListNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['posted-comments posted-comments--sent']

  enums: Ember.inject.service("enums-utils")
  refresher: Ember.inject.service("refresher-tool")

  sortProperties: ['createdWhen:desc']
  sortedNotifications: Ember.computed.sort('notifications', 'sortProperties')

  showHidden: Ember.computed.not 'refresher.shouldFilterNotificationsOnStatus'
  tooltipShowHidden: Ember.computed 'showHidden', ->
    if @get('showHidden') then return "Click to collapse"
    else return "Click to expand"

  shownNotifications: Ember.computed 'sortedNotifications', 'sortedNotifications.@each.status', ->
    notifs = []
    enums = @get('enums')
    @get('sortedNotifications').forEach (notif) ->
      if notif.get('status') is enums.get('status.show') then notifs.push(notif)
    notifs

  hiddenNotifications: Ember.computed 'sortedNotifications', 'sortedNotifications.@each.status', ->
    notifs = []
    enums = @get('enums')
    @get('sortedNotifications').forEach (notif) ->
      if notif.get('status') is enums.get('status.hide') then notifs.push(notif)
    notifs

  emptyShownNotifications: Ember.computed 'shownNotifications.length', ->
    if @get('shownNotifications.length') > 0 then return false
    else return true
  emptyHiddenNotifications: Ember.computed 'hiddenNotifications.length', ->
    if @get('hiddenNotifications.length') > 0 then return false
    else return true


  actions:
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
    toggleShowHidden: ->
      @toggleProperty('refresher.shouldFilterNotificationsOnStatus')
)

`export default ListNotificationsComponent`
