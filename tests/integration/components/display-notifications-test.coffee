`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'display-notifications', 'Integration | Component | display notifications', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{display-notifications}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#display-notifications}}
      template block text
    {{/display-notifications}}
  """

  assert.equal @$().text().trim(), 'template block text'
