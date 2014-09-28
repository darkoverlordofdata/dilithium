/*+--------------------------------------------------------------------+
#| BaseGame.dart
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# dilithium
#
#   Game Template
*/
part of dilithium;

class BaseGame extends State {

  String path;
  Config config;
  Game game;


  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Start the game
   *
   * returns this
   */
  BaseGame(Config this.config) {

    print("Base Game initialized");
    game = new Game(800, 600, AUTO, '', this);

  }

  create() {
    game.state.add(config.boot, new Boot(this.config));
    game.state.add(config.assets, new Assets(this.config));
  }
}


