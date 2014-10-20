/**
 *--------------------------------------------------------------------+
 * Li2State.dart
 *--------------------------------------------------------------------+
 * Copyright DarkOverlordOfData (c) 2014
 *--------------------------------------------------------------------+
 *
 * This file is a part of dilithium
 *
 * dilithium is free software; you can copy, modify, and distribute
 * it under the terms of the MIT License
 *
 *--------------------------------------------------------------------+
 *
 */
part of dilithium;

class Li2State extends Phaser.State {

  Li2Button addButton(num x, num y, String key, Phaser.TextStyle style, String text, Function callback) {
    var button = new Li2Button(game, x, y, key, style, text, callback);
    add.group().add(button);
    return button;

  }
}
