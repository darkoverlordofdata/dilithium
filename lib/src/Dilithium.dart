/**
 *--------------------------------------------------------------------+
 * Dilithium.dart
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

class Dilithium extends State {

  String path;
  Li2Config config;
  Game game;

  /**
   * Using resources...
   */
  static async.Future using(String path) {

    // Secret Template, Man...
    var script = document.createElement('script');
    script.setAttribute('src', 'packages/dilithium/liquid-0.0.7.min.js');
    querySelector('head').append(script);

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
      Li2Config config = new Li2Config(source, path);
      String to_arrays = config.paths['arrays'];
      String to_strings = config.paths['strings'];
      String to_preferences = config.paths['preferences'];

      HttpRequest.getString("$path/$to_preferences")
      .then((String preferences) {
        HttpRequest.getString("$path/$to_arrays")
        .then((String arrays) {
          // get localized strings (if they exist)
          String to_locale = to_strings.replaceAll('.yaml', "-$lang.yaml");
          HttpRequest.getString("$path/$to_locale")
          .then((String strings) {
            config.setStrings(strings);
            config.setArrays(arrays);
            config.setPreferences(preferences);
            completer.complete(config);
          })
          // get default (if they don't exist)
          .catchError((Error e) {
            HttpRequest.getString("$path/$to_strings")
            .then((String strings) {
              config.setStrings(strings);
              config.setArrays(arrays);
              config.setPreferences(preferences);
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
  Dilithium(Li2Config this.config) {

    print("Base Game initialized");
    game = new Game(config.width, config.height, config.renderer, '', this);

  }

  /**
   *
   */
  create() {
    game.state.add(config.boot, new Li2Boot(this.config));
    game.state.add(config.assets, new Li2Assets(this.config));
    game.state.add(config.menu, levels());
    game.state.start(config.boot);

  }

  Li2State levels(); // override to define game states

}


