`import Ember from 'ember'`
`import layout from '../templates/components/display-notification'`

DisplayNotificationComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-notification']
  tagName: 'tr'
)

`export default DisplayNotificationComponent`
