`import Ember from 'ember';`
`import layout from '../templates/components/display-comment';`


DisplayComment = Ember.Component.extend
  layout: layout
  classNames:['display-comment']
  editing: Ember.computed.not 'isNotModify'
  isNotModify: true
  textContent: ''
  commentUser: undefined
  checkStatus : 'active'

  checked: Ember.computed "isActive", ->
    if @get('isActive')
      "checked"
    else
      "unchecked"
  init: ->
    @currUser = this.get('currentUser')
    @commentUser = this.get('comment').get('authorId')
    @textContent = this.get('comment').get('content')
    this._super()

  isActive: Ember.computed "comment.status", ->
    (@checkStatus is @get('comment').get('status'))


  changeModifyState: ->
    if !this.isNotModify
      if this.get('textContent') && this.get('textContent').trim().length
        this.set('isNotModify', true)
        this.get('comment').set('content', this.get('textContent'))
        @sendAction 'modifyComment', this.get('comment')
      else
        buff = this.get('comment').get('content')
        this.set('textContent', buff)
    else
      this.set('isNotModify', false)

  actions:
    deleteComment: (comment) ->
      @sendAction 'deleteComment', comment

    textContentModified: (event) ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.target.value = this.get('textContent')
        this.changeModifyState()
        return false
      else
        this.set('textContent', event.target.value)

    changeModifyState: ->
      this.changeModifyState()

    changeStatus: ->
      if(this.get('comment.isModifiable'))
        if(this.get('comment').get('status') is "active")
          this.get('comment').set('status', 'inactive')
        else
          this.get('comment').set('status', 'active')
        @sendAction 'modifyComment', this.get('comment')

`export default DisplayComment;`
