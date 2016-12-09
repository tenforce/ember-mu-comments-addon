`import Ember from 'ember'`
`import layout from '../templates/components/list-notifications'`

ListNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['list-notifications']
  sortProperties: ['creationDate:desc']
  sortedNotifications: Ember.computed.sort('notifications', 'sortProperties')

  refresher: Ember.inject.service("refresher-tool")

  emptyNotifications: Ember.computed 'notifications.length', ->
    if @get('notifications.length') > 0 then return false
    else return true

  showHidden: Ember.computed.not 'refresher.shouldFilterNotificationsOnStatus'

  actions:
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
    toggleShowHidden: ->
      @toggleProperty('refresher.shouldFilterNotificationsOnStatus')
)

`export default ListNotificationsComponent`
