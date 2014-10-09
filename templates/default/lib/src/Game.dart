/**
 *--------------------------------------------------------------------+
 * Game.dart
 *--------------------------------------------------------------------+
 * Copyright {{project.author}} (c) {{project.copyright}}
 *--------------------------------------------------------------------+
 *
 * This file is a part of {{ project.libname }}
 *
 * {{ project.libname }} is free software; you can copy, modify, and distribute
 * it under the terms of the {{ project.license }}
 *
 *--------------------------------------------------------------------+
 *
 */
part of {{ project.libname }};

class Game  extends Dilithium {

  static const GEMSIZE    = 48;     // Gem size constant in pixels
  static const MARGINTOP  = 2;      // Margin top equal to 2 gems height
  static final List GEMTYPES = [    // All gem types:
      "blue",
      "cyan",
      "green",
      "magenta",
      "orange",
      "pink",
      "red",
      "yellow"
  ];

  cordova.Device device;
  Li2Template template;

  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Start the game
   *
   * returns this
   */
  Game(config, this.template, this.device): super(config) {

    print("Class Game initialized");
  }

  /**
   * Define each of the game states
   */
  State levels() {

    game.state
      ..add('Levels',       new Levels(config))
      ..add('Credits',      new Credits(config))
      ..add('Scores',       new Scores(config))
      ..add('Preferences',  new Preferences(config, template))
      ..add('GameOver',     new GameOver(config));

    return new Menu(config);

  }

}
