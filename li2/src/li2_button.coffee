#+--------------------------------------------------------------------+
#| Li2Button.coffee
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
lib = require('../../lib')

#
# == Initialize ==
#
#   * Start loading the the splash screen image
#   * Configure the game engine to the environment
#
class lib.Li2Button extends Phaser.Button

  label: null

  constructor:(game, x, y, key, style, text, callback) ->

    super game, x, y, key, callback

    @label = new Phaser.Text(game, 0, 0, text, style)
    addChild(@label)
    setLabel(text)


  setLabel:(text) ->

    @label.setText text
    @label.x = Math.floor((@width - @label.width)/2)
    @label.y = Math.floor((@height - @label.height)/2)
