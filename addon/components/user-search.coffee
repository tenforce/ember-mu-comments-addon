`import Ember from 'ember'`
`import layout from '../templates/components/user-search'`

UserSearchComponent = Ember.Component.extend(
  layout:layout
  tagName: ''

  maxUsers: 3

  # only show the users that can be added, using the search string and the already assigned users
  filteredUsers: Ember.computed 'availableUsers', 'searchString', 'assignedUsers.length', ->
    users = []
    searchString = @get('searchString')
    @get('availableUsers').forEach (user) =>
      if @get('assignedUsers').contains(user)
      else
        if searchString
          if(((user.get('name').toLowerCase()).indexOf((searchString).toLowerCase())) >= 0) then users.push(user)
        else users.push(user)
    users.slice(0, @get('maxUsers'))
  searchString: ""

  endSearch: ->
    firstmatch = @get('filteredUsers')[0]
    if firstmatch then @finishAddAssigned(firstmatch)
    else @finishCloseSearch()
  finishAddAssigned: (user) ->
    @sendAction('addAssigned', user)
    if @get('closeAfterAdding') then @finishCloseSearch()
    else @clearField()
  clearField: ->
    @set('searchString', '')
  finishCloseSearch: ->
    @clearField()
    @sendAction('closeSearch')
  actions:
    addAssigned: (user) ->
      @finishAddAssigned(user)
    closeSearch: ->
      @finishCloseSearch()
    keyPressSearch: (value, event) ->
      if(event.keyCode == 13 && not event.shiftKey)
        event.preventDefault()
        @endSearch()
)

`export default UserSearchComponent`
