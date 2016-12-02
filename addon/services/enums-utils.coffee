`import Ember from 'ember'`

EnumsUtilsService = Ember.Service.extend
  status:
    {
      solved: "solved"
      unsolved: "unsolved"
      deleted: "deleted"
      hide: "hide"
      show: "show"
    }

`export default EnumsUtilsService`
