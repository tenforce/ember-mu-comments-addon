`import Ember from 'ember'`
`import layout from '../templates/components/display-comments'`

DisplayCommentsComponent = Ember.Component.extend(
  store: Ember.inject.service()
  intl: Ember.inject.service()
  layout: layout
  classNames:['display-comments']
  isDisplayed: false
  comments: undefined

  aboutChanged: Ember.observer('about', () ->
    @getComments()
  ).on('init')

  init: ->
    @get('intl').setLocale('en-us')
    @get('about')
    this._super()

  getComments: () -> (
    @get('store').query('comment',
      filter:
        type: 'about-id'
        value: @get('about')
        status: '"active","inactive"'
      ## Have to use because otherwise IE caches the query and never fetches it again
        timestamp: new Date())
    .then (result) =>
      @set 'comments', result
  )


  actions:
    showComments: ->
      if @isDisplayed
        this.set('isDisplayed', false)
      else
        this.set('isDisplayed', true)

    createComment: (comment) ->
      comment.aboutId = this.get('about')
      comment.date = new Date()
      comment.status = "inactive"
      newc = @get('store').createRecord('comment', comment)
      newc.save().then =>
        @getComments()
      return

    deleteComment: (comment) ->
      comment?.destroyRecord().then(=>
        @getComments()
      )
      return

    modifyComment: (comment) ->
      comment?.save().then(=>
        @getComments()
      )
      return

)

`export default DisplayCommentsComponent`
