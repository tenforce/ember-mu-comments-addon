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
    @get('store').query('comment', filter:
      type: 'about-id'
      value: @get('about')
      status: '"active","inactive"')
    .then (result) =>
      @set 'comments', result
  )


  actions:
    showComments: ->
      if @isDisplayed
        this.set('isDisplayed', false)
      else
        this.set('isDisplayed', true)
    createComment: (newcomment) ->
      newcomment.aboutId = this.get('about')
      newcomment.date = new Date()
      newc = @get('store').createRecord('comment', newcomment)
      newc.save()
      @getComments()
      return

    deleteComment: (comment) ->
      comment?.destroyRecord()
      return

    modifyComment: (modcomment) ->
      modcomment.save()
      return

)

`export default DisplayCommentsComponent`
