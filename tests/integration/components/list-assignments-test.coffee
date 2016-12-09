`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'list-assignments', 'Integration | Component | list assignments', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{list-assignments}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#list-assignments}}
      template block text
    {{/list-assignments}}
  """

  assert.equal @$().text().trim(), 'template block text'
