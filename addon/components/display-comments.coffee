`import Ember from 'ember'`
`import layout from '../templates/components/display-comments'`

DisplayCommentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-comments']
  store: Ember.inject.service()
  # intl is needed for the format helper
  intl: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")
  refresher: Ember.inject.service("refresher-tool")

  buttonTabIndex: "-1"
  idbutton: "showComments"
  isDisplayed: false

  # data is being fetched from the refresher tool service, which polls data every x seconds
  comments: Ember.computed.alias 'refresher.comments'
  users: Ember.computed.alias 'refresher.users'

  loading: Ember.computed 'refresher.comments', ->
    if @get('refresher.comments') then return false
    else return true
  # htmlsafe is needed to display some html in hbs from a variable
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "View comments"
  targetAttachment:'bottom middle'
  attachment:'top right'
  init: ->
    @get('intl').setLocale('en-us')
    this._super()

  aboutObserver: Ember.observer('about.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    @set('refresher.about', @get('about'))

  # after creating a comment, we need to first refresh them and then get the newly created notifications
  finishGetComments: () ->
    @get('refresher')?.refreshComments().then =>
      @get('refresher')?.refreshNotifications()

  actions:
    toggleDisplay: ->
      @toggleProperty('isDisplayed')

    refresh: ->
      @finishGetComments()

)

`export default DisplayCommentsComponent`
