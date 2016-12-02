`import Ember from 'ember';`
`import layout from '../templates/components/list-comments';`

ListComment = Ember.Component.extend
  layout: layout
  classNames:['list-comments']

  sortProperties: ['creationDate:desc']
  sortedComments: Ember.computed.sort('comments', 'sortProperties')

  sortComments: (a, b) ->
    if a.get('creationDate') > b.get('creationDate') then return -1
    else if a.get('creationDate') < b.get('creationDate') then return 1
    else return 0
  actions:
    createComment: (comment) ->
      this.sendAction('createComment', comment)
    deleteComment: (comment) ->
      this.sendAction('deleteComment', comment)


`export default ListComment;`
