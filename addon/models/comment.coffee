`import DS from 'ember-data';`


Comment = DS.Model.extend
  content: DS.attr()
  status: DS.attr()
  date: DS.attr('date')
  authorId: DS.attr()
  authorLabel : DS.attr()
  aboutId: DS.attr()
  dateFormat: DS.attr()
  isModifiable: DS.attr('boolean')

`export default Comment;`
