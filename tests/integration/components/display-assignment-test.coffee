`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'display-assignment', 'Integration | Component | display assignment', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{display-assignment}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#display-assignment}}
      template block text
    {{/display-assignment}}
  """

  assert.equal @$().text().trim(), 'template block text'
