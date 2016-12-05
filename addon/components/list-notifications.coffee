`import Ember from 'ember'`
`import layout from '../templates/components/list-notifications'`

ListNotificationsComponent = Ember.Component.extend(
  layout: layout
  classNames:['list-notifications']

  sortProperties: ['creationDate:desc']
  sortedNotifications: Ember.computed.sort('notifications', 'sortProperties')

  emptyNotifications: Ember.computed 'notifications.length', ->
    if @get('notifications.length') > 0 then return false
    else return true
)

`export default ListNotificationsComponent`
