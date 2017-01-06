`import Ember from 'ember'`
`import layout from '../templates/components/display-notification'`

DisplayNotificationComponent = Ember.Component.extend(
  layout: layout
  classNames:['comment']
  classNameBindings: ['notification.solved:solved:unsolved', 'notification.status']

  enums: Ember.inject.service("enums-utils")
  dateFormat: Ember.inject.service("date-format")

  # fetching the names of assignedTo users
  assignedTo: Ember.computed 'notification.assignments', 'notification.assignments.@each.assignedTo', ->
    @get('notification.assignments').then (assignments) ->
      promises = []
      assignments.forEach (assignment) ->
        promises.push(assignment?.get('assignedTo'))
      Ember.RSVP.Promise.all(promises).then (results) ->
        users = []
        results.forEach (result) ->
          users.push(result.get('name'))
        users.join(',')

  actions:
    handleClick: (notification) ->
      @sendAction('handleClick', notification)
    toggleStatus: (notification) ->
      if(notification.get('status') is @get('enums.status.show')) then notification.set('status', @get('enums.status.hide'))
      else if(notification.get('status') is @get('enums.status.hide')) then notification.set('status', @get('enums.status.show'))
      notification.save()
)

`export default DisplayNotificationComponent`
