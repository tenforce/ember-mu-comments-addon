`import Ember from 'ember'`
`import SearchUtilsMixin from '../../../mixins/search-utils'`
`import { module, test } from 'qunit'`

module 'Unit | Mixin | search utils'

# Replace this with your real tests.
test 'it works', (assert) ->
  SearchUtilsObject = Ember.Object.extend SearchUtilsMixin
  subject = SearchUtilsObject.create()
  assert.ok subject
