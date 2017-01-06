`import Ember from 'ember'`
`import layout from '../templates/components/list-assignments'`

ListAssignmentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['posted-comments posted-comments--inbox']

  enums: Ember.inject.service("enums-utils")
  refresher: Ember.inject.service("refresher-tool")

  sortProperties: ['notification.createdWhen:desc']
  sortedAssignments: Ember.computed.sort('assignments', 'sortProperties')

  showHidden: Ember.computed.not 'refresher.shouldFilterNotificationsOnStatus'
  tooltipShowHidden: Ember.computed 'showHidden', ->
    if @get('showHidden') then return "Click to collapse"
    else return "Click to expand"

  shownAssignments: Ember.computed 'sortedAssignments', 'sortedAssignments.@each.status', ->
    notifs = []
    enums = @get('enums')
    @get('sortedAssignments').forEach (notif) ->
      if notif.get('status') is enums.get('status.show') then notifs.push(notif)
    notifs

  hiddenAssignments: Ember.computed 'sortedAssignments', 'sortedAssignments.@each.status',->
    notifs = []
    enums = @get('enums')
    @get('sortedAssignments').forEach (notif) ->
      if notif.get('status') is enums.get('status.hide') then notifs.push(notif)
    notifs

  emptyShownAssignments: Ember.computed 'shownAssignments.length', ->
    if @get('shownAssignments.length') > 0 then return false
    else return true
  emptyHiddenAssignments: Ember.computed 'hiddenAssignments.length', ->
    if @get('hiddenAssignments.length') > 0 then return false
    else return true

  actions:
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
    toggleShowHidden: ->
      @toggleProperty('refresher.shouldFilterNotificationsOnStatus')
)

`export default ListAssignmentsComponent`
