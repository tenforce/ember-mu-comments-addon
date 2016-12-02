`import Ember from 'ember';`
`import layout from '../templates/components/new-comment';`

NewComment = Ember.Component.extend
  layout: layout
  classNames:['new-comment']
  store: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")
  language: Ember.computed -> @get('user.language') || "en"
  languageObserver: Ember.observer('language', 'comment',  () ->
    @set('comment.messageLanguage', @get('language'))
    @set('comment.language', @get('language'))
  ).on('init')

  init: ->
    @_super()
    @newComment()
  didInsertElement: ->
    Ember.run.next =>
      @$('textarea')[0]?.focus()
  newComment: ->
    @set('assignedUsers', [])
    @set('comment', @get('store').createRecord('comment'))
  textAreaPlaceholder: "Please enter your comment"
  addButtonLabel: "Add comment"
  comment: undefined
  showModal: true

  assignedUsers: []
  disableComment: false
  disableSearch: false
  previousKey: undefined
  searchString: ""
  availableUsers: Ember.computed 'users', ->
    users = []
    @get('users').forEach (user) =>
      unless user.get('id') is @get('user.id') then users.push(user)
    return users
  filteredUsers: Ember.computed 'availableUsers', 'searchString', ->
    users = []
    searchString = @get('searchString')
    @get('availableUsers').forEach (user) =>
      if searchString
        if((user.get('name').indexOf(searchString)) > 0) then users.push(user)
      else users.push(user)
    users

  creatingComment:  ->
    comment = @get('comment')
    unless comment.get('language') then comment.set('language', @get('language'))
    comment.set('status', @get('enums.status.unsolved'))
    comment.set('creationDate', (new Date()).toISOString())
    comment.set('author', @get('user'))
    comment.set('about', @get('about'))
    # TODO : probably where we should generate the notifications
    @sendAction 'createComment', comment
    @newComment()


  beginSearch: ->
    @set('searchingForUser', true)
    @set('disableComment', true)
    Ember.run.next =>
      @$('#userSearch')[0]?.focus()
  endSearch: ->
    firstmatch = @get('filteredUsers')[0]
    if firstmatch then @finishAddAssigned(firstmatch)
    @set('searchingForUser', false)
    @set('disableComment', false)
    Ember.run.next =>
      @$('textarea')[0]?.focus()

  finishAddAssigned: (user) ->
    unless @get('assignedUsers').contains(user) then @get('assignedUsers').pushObject(user)
    @get
  finishRemoveAssigned: (user) ->
    @get('assignedUsers').removeObject(user)
  actions:
    keyPressComment: () ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.preventDefault()
        @creatingComment()
      else
        debugger
        if event.key is ":" and @get('previousKey') is "@" then @beginSearch()
      @set('previousKey', event.key)
    keyPressSearch: () ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.preventDefault()
        @endSearch()

    addAssigned: (user) ->
      @finishAddAssigned(user)
    removeAssigned: (user) ->
      @finishRemoveAssigned(user)



`export default NewComment;`
