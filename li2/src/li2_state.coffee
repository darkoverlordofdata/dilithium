#+--------------------------------------------------------------------+
#| Li2State.coffee
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
class lib.Li2State extends Phaser.State

  addButton:(x, y, key, style, text, callback)->
    button = new lib.Li2Button(@game, x, y, key, style, text, callback)
    @add.group().add(button)
    return button
