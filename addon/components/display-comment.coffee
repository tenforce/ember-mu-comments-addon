`import Ember from 'ember';`
`import layout from '../templates/components/display-comment';`

DisplayComment = Ember.Component.extend
  layout: layout
  classNames:['display-comment']
  enums: Ember.inject.service("enums-utils")

  author: Ember.computed.alias 'comment.author'
  authorName: Ember.computed 'author', ->
    @get('author').then (author) ->
      return author.get('name') || "anonymous"
  editing: false
  loading: false
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  isSolved: Ember.computed 'comment.status', 'enums.status.solved', ->
    return @get('comment.status') is @get('enums.status.solved')

  allowModification: Ember.computed 'user', 'author', ->
    if @get('user.id') is @get('author.id') then return true
    else return false
  disable: Ember.computed.or 'allowedModification', 'loading'

  finishEditing: ->
    @set('loading', true)
    @set('editing', false)
    @set('comment.lastModified', new Date().toISOString())
    @get('comment').save().then =>
      unless @get('isDestroyed') then @set 'loading', false
    return @get('comment')

  finishChangeStatus: ->
    unless(this.get('disable'))
      if(this.get('comment.status') is @get('enums.status.unsolved'))
        this.set('comment.status', @get('enums.status.solved'))
      else if(this.get('comment.status') is @get('enums.status.solved'))
        this.set('comment.status', @get('enums.status.unsolved'))
      @set('loading', true)
      @set('editing', false)
      promises = []
      user = @get('user')
      status = @get('comment.status')
      @get('comment.notifications').then (notifications) =>
        notifications.forEach (notification) =>
          if status is @get('enums.status.solved')
            promises.push(notification.solve(user, new Date().toISOString()))
          else if status is @get('enums.status.unsolved')
            promises.push(notification.unsolve(user, new Date().toISOString()))
      promises.push(@get('comment').save())
      Ember.RSVP.Promise.all(promises).then =>
        unless @get('isDestroyed') then @set 'loading', false
      return @get('comment')

  actions:
    deleteComment: (comment) ->
      @sendAction 'deleteComment', comment

    keyPress: () ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.preventDefault()
        @finishEditing()

    toggleEditing: () ->
      if @get('editing') then @finishEditing()
      else
        @toggleProperty('editing')

    changeStatus: ->
      @finishChangeStatus()

`export default DisplayComment;`
