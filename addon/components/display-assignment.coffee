`import Ember from 'ember'`
`import layout from '../templates/components/display-assignment'`

DisplayAssignmentComponent = Ember.Component.extend(
  layout: layout
  classNames:['comment']
  classNameBindings: ['assignment.notification.solved:solved:unsolved', 'assignment.status']

  enums: Ember.inject.service("enums-utils")
  dateFormat: Ember.inject.service("date-format")

  actions:
    # when we click on some cells, we need to warn the platform to handle it
    handleClick: (notification) ->
      @sendAction('handleClick', notification)

    toggleStatus: (notification) ->
      if(notification.get('status') is @get('enums.status.show')) then notification.set('status', @get('enums.status.hide'))
      else if(notification.get('status') is @get('enums.status.hide')) then notification.set('status', @get('enums.status.show'))
      notification.save()
)

`export default DisplayAssignmentComponent`
