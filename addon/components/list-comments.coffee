`import Ember from 'ember';`
`import layout from '../templates/components/list-comments';`

# TODO : Remove the Sort possibilities, not useful enough

ListComment = Ember.Component.extend
  sortedComments: null
  sortProperties: null
  sortLabel: null
  isDescSort: true
  init: ->
    this._super()
    if @isDescSort
      this.set('sortProperties',['date:desc'])
      this.set('sortLabel', "Desc")
    else
      @sortProperties= ['date:asc']
      this.set('sortLabel', "Asc")
    @sortedComments = Ember.computed.sort('comments', 'sortProperties')
  layout: layout
  classNames:['list-comments']
  actions:
    createComment: (comment) ->
      this.sendAction('createComment', comment)
    deleteComment: (comment) ->
      this.sendAction('deleteComment', comment)
    modifyComment: (comment) ->
      this.sendAction('modifyComment', comment)


`export default ListComment;`
