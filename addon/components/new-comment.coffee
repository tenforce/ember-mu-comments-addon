`import Ember from 'ember';`
`import layout from '../templates/components/new-comment';`

NewComment = Ember.Component.extend
  layout: layout
  classNames:['new-comment']

  didInsertElement: ->
    @set('newCommentContent', "")
    Ember.run.next =>
      this.$('#newCommentInput')[0].focus()

  finishCreateComment:  ->
    newcontent = this.get('newCommentContent')
    if newcontent && newcontent.trim().length
      newcomment =
        content: newcontent
        status: 'active'

      @set('newCommentContent', '')
      @sendAction 'createComment', newcomment

  actions:
    createComment:  ->
      this.finishCreateComment()
      # TODO : How to clear the textArea after this?

    textContentModified: (event) ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.target.value = ""
        this.finishCreateComment(event)
        return false
      else
        this.set('newCommentContent', event.target.value)


`export default NewComment;`
