`import Ember from 'ember';`
`import layout from '../templates/components/display-comment';`


DisplayComment = Ember.Component.extend
  layout: layout
  classNames:['display-comment']

  isNotModify: true
  modValue: '-> Edit'
  textContent: ''
  commentUser: undefined
  checkStatus : 'active'
  init: ->
    @currUser = this.get('currentUser')
    @commentUser = this.get('comment').get('authorId')
    @textContent = this.get('comment').get('content')
    this._super()

  isActive: Ember.computed ->
    (@checkStatus is @get('comment').get('status'))

  isNotAllowed: Ember.computed ->
    (!@get('comment').get('isModifiable'))


  actions:
    deleteComment: (idcomment) ->
      @sendAction 'deleteComment', idcomment
    changeModifyState: ->
      if !this.isNotModify
        if this.get('textContent') && this.get('textContent').length
          this.set('isNotModify', true)
          this.set('modValue', '-> Edit')
          this.get('comment').set('content', this.get('textContent'))
          @sendAction 'modifyComment', this.get('comment')
        else this.set('textContent', this.get('comment').get('content'))
      else
        this.set('isNotModify', false)
        this.set('modValue', '-> Save')

    changeStatus: ->
      if(this.get('comment').get('status') is "active")
        this.get('comment').set('status', 'inactive')
      else
        this.get('comment').set('status', 'active')
      @sendAction 'modifyComment', this.get('comment')

`export default DisplayComment;`
