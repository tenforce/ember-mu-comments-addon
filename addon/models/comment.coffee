`import DS from 'ember-data';`

Comment = DS.Model.extend
  language: DS.attr('string')
  content: DS.attr()
  messageObject: Ember.computed 'content',
    get: (key) ->
      return @get('content')?[0]
    set: (key, value) ->
      arr = []
      arr.push(value)
      @set('content', arr)
      value
  message: Ember.computed 'messageObject',
    get: (key) ->
      (@get('messageObject.content') || "").replace(/\\n/g, String.fromCharCode(13, 10) )
    set: (key, value) ->
      obj = @get('messageObject')
      unless obj then obj = {content: "", language: ""}
      obj['content'] = value
      @set('messageObject', obj)
      value
  messageLanguage: Ember.computed 'messageObject',
    get: (key) ->
      @get('messageObject.language') || ""
    set: (key, value) ->
      obj = @get('messageObject')
      unless obj then obj = {content: "", language: ""}
      obj['language'] = value
      @set('messageObject', obj)
      value
  status: DS.attr('string')
  about: DS.belongsTo('concept', {inverse:null})
  author: DS.belongsTo('user', {inverse:null})
  creationDate: DS.attr('string')
  modificationDate: DS.attr('string')
  notifications: DS.hasMany('comment-notification', {inverse:null})

  destroyRecord: () ->
    @get('notifications').forEach (notification) ->
      notification.destroyRecord()
    @_super(arguments...)


`export default Comment;`
