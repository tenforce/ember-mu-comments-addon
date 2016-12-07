`import Ember from 'ember'`
`import layout from '../templates/components/display-comments'`

DisplayCommentsComponent = Ember.Component.extend(
  layout: layout
  classNames:['display-comments']
  store: Ember.inject.service()
  intl: Ember.inject.service()
  enums: Ember.inject.service("enums-utils")
  refresher: Ember.inject.service("refresher-tool")

  buttonTabIndex: "-1"
  idbutton: "showComments"
  isDisplayed: false
  comments: Ember.computed.alias 'refresher.comments'
  users: Ember.computed.alias 'refresher.users'

  loading: Ember.computed 'refresher.comments', ->
    if @get('refresher.comments') then return false
    else return true
  loadingPlaceholder: Ember.computed ->
    return Ember.String.htmlSafe("<i class=\"fa fa-spinner fa-pulse\"></i>")
  tooltipTitle: "view comments"

  init: ->
    @get('intl').setLocale('en-us')
    this._super()

  aboutObserver: Ember.observer('about.id', () ->
    @reinitialize()
  ).on('init')

  reinitialize: () ->
    @set('refresher.about', @get('about'))

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
