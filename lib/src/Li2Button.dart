/**
 *--------------------------------------------------------------------+
 * Li2Button.dart
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


class Li2Button extends Phaser.Button {

  Phaser.Text label;

  Li2Button(Phaser.Game game, num x, num y, String key, Phaser.TextStyle style, String text, Function callback):
        super(game, x, y, key, callback) {

    label = new Phaser.Text(game, 0, 0, text, style);
    addChild(label);
    setLabel(text);

  }

  setLabel(String text) {
    label.setText(text);
    label.x = ((width - label.width)/2).floor();
    label.y = ((height - label.height)/2).floor();
  }
}