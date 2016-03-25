`import Ember from 'ember';`
`import layout from '../templates/components/new-comment';`

NewComment = Ember.Component.extend
  layout: layout
  classNames:['new-comment']
  actions: createComment: (newcontent) ->
    if newcontent && newcontent.length
      newcomment =
        content: newcontent
        status: 'active'

      @sendAction 'createComment', newcomment
      this.set('newCommentContent', '')


`export default NewComment;`
