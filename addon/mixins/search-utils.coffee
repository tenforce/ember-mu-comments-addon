`import Ember from 'ember'`

SearchUtilsMixin = Ember.Mixin.create

  handleEnter: ->
    #Replace by whatever you need to do when pressing ENTER
    undefined

  #Replace if assignedUsers shouldn't be empty
  assignedUsers: []

  #Override if needed
  availableUsers: Ember.computed 'users', ->
    users = []
    @get('users').forEach (user) =>
      unless user.get('id') is @get('user.id') then users.push(user)
    return users

  cursorPosition: undefined

  #Whether the search should close after adding one user
  multiAdds: true

  #Store the previous key pressed
  previousKey: undefined

  #Whether the comment input should be disabled
  disableComment: false

  beginSearch: ->
    @set('cursorPosition', @$('textarea')[0].selectionStart || 0)
    @set('searchingForUser', true)
    # @set('disableComment', true)
    Ember.run.next =>
      @$("#userSearch#{@get('index')}")[0]?.focus()

  endSearch: ->
    firstmatch = @get('filteredUsers')[0]
    if firstmatch then @finishAddAssigned(firstmatch)
    @finishCloseSearch()

  finishCloseSearch: ->
    @set('searchString', '')
    @set('searchingForUser', false)
    cursPos = @get('cursorPosition')
    Ember.run.next =>
      @$('textarea')[0]?.focus()
      if cursPos then @$('textarea')[0]?.setSelectionRange(cursPos, cursPos)

  finishAddAssigned: (user) ->
    unless @get('assignedUsers').contains(user) then @get('assignedUsers').pushObject(user)
    cursPos = @get('cursorPosition')
    Ember.run.next =>
      @$('textarea')[0]?.focus()
      if cursPos then @$('textarea')[0]?.setSelectionRange(cursPos, cursPos)

  finishRemoveAssigned: (user) ->
    @get('assignedUsers').removeObject(user)

  actions:
    closeSearch: ->
      @finishCloseSearch()

    keyPress: (value, event) ->
      # if it's a transform key, we just let it fly away
      unless event.shiftKey or event.ctrlKey or event.altKey or (event.keyCode is 225)
        # if enter without shift, then we confirm
        if(event.keyCode == 13)
          event.preventDefault()
          @handleEnter()

    addAssigned: (user) ->
      @finishAddAssigned(user)
    removeAssigned: (user) ->
      @finishRemoveAssigned(user)

`export default SearchUtilsMixin`
