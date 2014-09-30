/**
 +--------------------------------------------------------------------+
 | Scores.dart
 +--------------------------------------------------------------------+
 | Copyright DarkOverlordOfData (c) 2014
 +--------------------------------------------------------------------+
 |
 | This file is a part of {{ project.libname }}
 |
 | {{ project.libname }} is free software; you can copy, modify, and distribute
 | it under the terms of the {{ project.license }}
 |
 +--------------------------------------------------------------------+

    {{ project.name }}

    {{ project.description }}

 */
part of {{ project.libname }};

class Scores extends State {

  /**
   * == Scores ==
   *   * Show the splash screen
   *   * Show the scores
   */

  String text = "High Scores";

  var style = new TextStyle(font: "bold 20px Acme", fill: "#000");
  Sprite label;
  Config config;

  Scores(Config this.config);

  /**
   * State::create
   *
   * return	Nothing
   */
  create() {
    
    add
      ..sprite(0, 0, 'background')
      ..sprite(10, 10, 'icon');

    label = add.sprite(15, 125, 'scores');

    add
      ..text(120, 130, text, style)
      ..button(game.width / 2 - 38, game.height-45, 'backButton', goBack, this);

    label.alpha = 0.5;
}

  /**
   * Back
   *
   * return	Nothing
   */
  goBack(source, input, flag) {
    state.start(config.menu);
  }


}
