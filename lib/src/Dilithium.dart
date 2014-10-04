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

  /**
   * Using resources...
   */
  static async.Future using(String path) {
    async.Completer completer = new async.Completer();

    // get the browser locale setting
    String lang = window.navigator.language;
    // simplify english to use default
    if (lang == "en" || lang.startsWith("en-"))
      lang = '';
    else
      lang = "-$lang";

    //  get the core dilithium configuration
    HttpRequest.getString("$path/config.yaml")
    .then((String source) {
      Config config = new Config(source, path);
      HttpRequest.getString("$path/preferences.yaml")
      .then((String preferences) {
        HttpRequest.getString("$path/values/arrays.yaml")
        .then((String arrays) {
          // get localized strings (if they exist)
          HttpRequest.getString("$path/values/strings$lang.yaml")
          .then((String strings) {
            config.setStrings(strings);
            config.setArrays(arrays);
            config.setPreferences(preferences);
            completer.complete(config);
          })
          // get default (if they don't exist)
          .catchError((Error e) {
            HttpRequest.getString("$path/values/strings.yaml")
            .then((String strings) {
              config.setStrings(strings);
              completer.complete(config);
            });
          });
        });
      });
    });
    return completer.future;

  }

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
    game.state.add(config.menu, levels());
    game.state.start(config.boot);

  }

  State levels(); // override to define game states

}


