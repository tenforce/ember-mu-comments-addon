`import DS from 'ember-data'`

NotificationAssignment = DS.Model.extend {
  status: DS.attr('string')
  assignedTo: DS.belongsTo('user')
  notification: DS.belongsTo('comment-notification', {inverse:null})
}

`export default NotificationAssignment`
