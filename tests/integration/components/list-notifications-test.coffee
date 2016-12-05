`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'list-notifications', 'Integration | Component | list notifications', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{list-notifications}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#list-notifications}}
      template block text
    {{/list-notifications}}
  """

  assert.equal @$().text().trim(), 'template block text'
