/**
 *--------------------------------------------------------------------+
 * Li2Assets.dart
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

class Li2Assets extends State {

  /**
   * == Assets ==
   *   * Show the splash screen
   *   * Load the game assets
   */

  Sprite preloadBar;
  Sprite preloadBgd;
  Li2Config config;

  Li2Assets(Li2Config this.config);

  /**
   * State::preload
   *
   * return	Nothing
   */
  preload() {

    print("Class Li2Assets initializing");

    //  Splash...
    load.setPreloadSprite(add.sprite(0, 0, config.splashKey));

    //  Progress bar?
    if (config.showPreloadBar) {
      preloadBgd = add.sprite(game.width / 2 - 250, game.height - 100, config.preloadBgdKey);
      preloadBar = add.sprite(game.width / 2 - 250, game.height - 100, config.preloadBarKey);
      load.setPreloadSprite(preloadBar);

    }

    //  load audio
    if (config.audio != null) {
      config.audio.forEach((k, v) => load.audio(k, config.path+v));
    }

    //  load images
    if (config.images != null) {
      config.images.forEach((k, v) => load.image(k, config.path+v));
    }

    // load level tilesets
    if (config.levels != null) {
      config.levels.forEach((k, level) {
        var levelName = level['options']['map'];
        load.tilemap(levelName, config.path+"levels/$levelName.json", null, Tilemap.TILED_JSON);
      });
    }

    // load sprite images
    if (config.sprites != null) {
      config.sprites.forEach((key, sprite) {
        if (sprite['file'] is String) {
          load.spritesheet(key, sprite['file'], sprite['width'], sprite['height']);
        } else {
          if (sprite['selected'] == true) {
            load.spritesheet(key, sprite['file'][['sprite.selected']], sprite['width'], sprite['height']);
          }
          var ix = 0;
          sprite['file'].forEach((file) {
            load.spritesheet("$key[$ix]", file, sprite['width'], sprite['height']);
            ix++;
          });
        }
      });
    }
  }

  /**
   * State::create
   *
   * return	Nothing
   */
  create() {
    state.start(config.menu, true, false);
    
  }

}
