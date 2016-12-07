`import Ember from 'ember'`
`import layout from '../templates/components/user-search'`

UserSearchComponent = Ember.Component.extend(
  layout:layout
  filteredUsers: Ember.computed 'availableUsers', 'searchString', 'assignedUsers.length', ->
    users = []
    searchString = @get('searchString')
    @get('availableUsers').forEach (user) =>
      if @get('assignedUsers').contains(user)
      else
        if searchString
          if(((user.get('name').toLowerCase()).indexOf((searchString).toLowerCase())) >= 0) then users.push(user)
        else users.push(user)
    users
  searchString: ""

  endSearch: ->
    firstmatch = @get('filteredUsers')[0]
    if firstmatch then @finishAddAssigned(firstmatch)
    else @finishCloseSearch()
  finishAddAssigned: (user) ->
    @sendAction('addAssigned', user)
    if @get('closeAfterAdding') then @finishCloseSearch()
  finishCloseSearch: ->
    @sendAction('closeSearch')
  actions:
    addAssigned: (user) ->
      @finishAddAssigned(user)
    closeSearch: ->
      @finishCloseSearch()
    keyPressSearch: ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.preventDefault()
        @endSearch()
)

`export default UserSearchComponent`
