#+--------------------------------------------------------------------+
#| template.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+
#
# == Initialize ==
#
#   * Start loading the the splash screen image
#   * Configure the game engine to the environment
#
li2.Template = class Template

  template: ''
  _template: null

  constructor:(template) ->
    parse template

  parse:(template) ->
    @template = template
    @_template = Liquid.Template.parse(template)
    return

  render:(variables) ->
    @_template.render(variables)

