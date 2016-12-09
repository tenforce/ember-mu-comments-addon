`import Ember from 'ember'`
`import layout from '../templates/components/list-assignments'`

ListAssignmentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['list-notifications']
  sortProperties: ['notification.creationDate:desc']
  sortedAssignments: Ember.computed.sort('assignments', 'sortProperties')

  refresher: Ember.inject.service("refresher-tool")

  emptyAssignments: Ember.computed 'assignments.length', ->
    if @get('assignments.length') > 0 then return false
    else return true

  showHidden: Ember.computed.not 'refresher.shouldFilterNotificationsOnStatus'

  actions:
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
    toggleShowHidden: ->
      @toggleProperty('refresher.shouldFilterNotificationsOnStatus')
)

`export default ListAssignmentsComponent`
