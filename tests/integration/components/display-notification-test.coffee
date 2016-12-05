`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'display-notification', 'Integration | Component | display notification', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{display-notification}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#display-notification}}
      template block text
    {{/display-notification}}
  """

  assert.equal @$().text().trim(), 'template block text'
