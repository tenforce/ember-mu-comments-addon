`import Ember from 'ember'`
`import layout from '../templates/components/display-comments'`

DisplayCommentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-comments']
  store: Ember.inject.service()
  intl: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")

  init: ->
    @get('intl').setLocale('en-us')
    this._super()

  aboutObserver: Ember.observer('about.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    promises = []
    promises.push @getComments()
    promises.push @getUsers()
    Ember.RSVP.Promise.all(promises).then =>
      @set 'loading', false

  isDisplayed: false
  comments: undefined
  buttonTabIndex: "-1"


  getUsers: () ->
    @get('store').query('user', {}).then (users) =>
      @set 'users', users

  getComments: () -> (
    @get('store').query('comment',
      filter:
        {
          about:
            id: @get('about.id')
        }
    )
    .then (result) =>
      @set 'comments', result
  )

  idbutton: "showComments"
  loading: true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view comments"

  actions:
    toggleDisplay: ->
      @toggleProperty('isDisplayed')

    createComment: (comment) ->
      comment.save().then  =>
        @getComments()
      return

    deleteComment: (comment) ->
      comment?.destroyRecord().then  =>
        @getComments()
      return

)

`export default DisplayCommentsComponent`
