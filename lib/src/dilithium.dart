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

class Hive {

  String name;
  String src;
  HttpRequest http;

  Hive(this.name, this.src) {
    this.http = new HttpRequest();

  }

}

abstract class Dilithium extends Phaser.State {

  String path;
  Li2Config config;
  Phaser.Game game;

  /**
   * Using resources...
   */
  static async.Future using(String path) {
    bool isCocoon = window.navigator.appVersion.contains("CocoonJS");

    print("Start Using");
    if (!isCocoon) {
      // for now, we'll use javascript
      var script = document.createElement('script');
      // Secret Template Man
      // Secret Template Man
      // They've given you a browser, and taken away your brain.
      script.setAttribute('src', 'packages/dilithium/liquid-0.0.7.min.js');
      querySelector('head').append(script);
    }
    async.Completer completer = new async.Completer();

    // get the browser locale setting
    String lang = window.navigator.language;

    /**
     * get the dilithium configuration hive
     */
    HttpRequest httpConfig = new HttpRequest();
    httpConfig.onReadyStateChange.listen((event) {
      if (httpConfig.readyState == 4 && httpConfig.status == 200) {

        /**
         * Main Config loaded
         */
        Li2Config config = new Li2Config(httpConfig.responseText, path);
        List hives = [];

        /**
         * Process hive sections, strings & arrays first
         */
        if (config.sections['strings'] != null) {
          hives.add(new Hive('strings', config.sections['strings']));
          if (config.locale) {
            hives.add(new Hive('strings', config.sections['strings'].replaceAll('.yaml', "-$lang.yaml")));
          }
        }
        if (config.sections['arrays'] != null) {
          hives.add(new Hive('arrays', config.sections['strings']));
        }
        config.sections.forEach((name, src) {
          if (name != 'strings' && name != 'arrays') {
            hives.add(new Hive(name, src));
          }
        });
        if (hives.length <= 0) {
          completer.complete(config);
          return;
        }

        /**
         * Que them up
         */
        int flag = 0; // how to tell
        int done = math.pow(2, hives.length)-1; // when we are done

        hives.forEach((Hive hive) {
          hive.http.onReadyStateChange.listen((event) {
            for (int check=0; check<hives.length; check++) {
              if (hives[check].http.readyState == 4
              && (hives[check].http.status == 200 || hives[check].http.status == 404)) {
                flag |= math.pow(2, check);
              }
            }

            if (flag == done) {
              /**
               * When we are done, process them in order
               */
              hives.forEach((Hive section) {
                if (section.http.status == 200) {
                  if (section.http.responseText.length > 0)
                    config.setSection(section.name, section.http.responseText);
                }
              });
              completer.complete(config);
            }
          });
        });
        hives.forEach((Hive hive) {
          hive.http.open('GET',"$path/${hive.src}");
          hive.http.send();
        });

      } else if (httpConfig.readyState == 4 && httpConfig.status != 200) {
        /**
         * Nope, we got butkus
         */
        Li2Config config = new Li2Config('', path);
        completer.complete(config);

      }
    });
    httpConfig.open('GET', "$path/config.yaml");
    httpConfig.send();
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

    print("Dilithium initialized");
    game = new Phaser.Game(config.width, config.height, config.renderer, config.id, this);

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


