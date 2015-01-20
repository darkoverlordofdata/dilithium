/**
 *--------------------------------------------------------------------+
 * Assets.dart
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

class Assets extends Phaser.State {

  /**
   * == Assets ==
   *   * Show the splash screen
   *   * Load the game assets
   */

  Phaser.Sprite preloadBar;
  Phaser.Sprite preloadBgd;
  Config config;

  Assets(Config this.config);

  /**
   * State::preload
   *
   * return	Nothing
   */
  preload() {

    print("Class Assets initializing");

    //  Splash...?
    if (config.showSplash) {
      load.setPreloadSprite(add.sprite(0, 0, config.splashKey));
    }

    //  Progress bar?
    if (config.showPreloadBar) {
      preloadBgd = add.sprite((config.width*0.5).floor(), (config.height*0.5).floor(), config.preloadBgdKey);
      preloadBgd.anchor.setTo(0.5, 0.5);
      preloadBar = add.sprite((config.width*0.5).floor(), (config.height*0.75).floor(), config.preloadBarKey);
      preloadBar.anchor.setTo(0.5, 0.5);
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
    if (config.tilemaps != null) {
      config.tilemaps.forEach((k, level) {
        var levelName = level['options']['map'];
        load.tilemap(levelName, config.path+"levels/$levelName.json", null, Phaser.Tilemap.TILED_JSON);
      });
    }

    // load sprite images
    if (config.sprites != null) {
      config.sprites.forEach((key, sprite) {
        if (sprite['file'] is String) {
          load.spritesheet(key, config.path+sprite['file'], sprite['width'], sprite['height']);
        } else {
          if (sprite['selected'] == true) {
            load.spritesheet(key, config.path+sprite['file'][['sprite.selected']], sprite['width'], sprite['height']);
          }
          var ix = 0;
          sprite['file'].forEach((file) {
            load.spritesheet("$key[$ix]", config.path+file, sprite['width'], sprite['height']);
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
