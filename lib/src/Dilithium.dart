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

typedef void Next(Config config);


class Dilithium extends State {

  String path;
  Config config;
  Game game;

  static async.Future using(String path) {
    async.Completer completer = new async.Completer();
    HttpRequest.getString("$path/config.li2")
    .then((String source) {
      completer.complete(new Config(source));
    });
    return completer.future;

  }

//  static launch(String path, Next callback) {
//    HttpRequest.getString("$path/config.li2")
//    .then((String source) => callback(new Config(source)));
//
//  }
  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Start the game
   *
   * returns this
   */
  Dilithium(Config this.config) {

    print("Base Game initialized");
    game = new Game(config.width, config.height, config.renderer, '', this);

  }

  /**
   *
   */
  create() {
    game.state.add(config.boot, new Boot(this.config));
    game.state.add(config.assets, new Assets(this.config));
  }
}


