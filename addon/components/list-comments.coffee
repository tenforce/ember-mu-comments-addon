`import Ember from 'ember';`
`import layout from '../templates/components/list-comments';`

ListComment = Ember.Component.extend
  layout: layout
  classNames:['list-comments']

  sortProperties: ['creationDate:desc']
  sortedComments: Ember.computed.sort('comments', 'sortProperties')

  actions:
    refresh: ->
      @sendAction('refresh')


`export default ListComment;`
