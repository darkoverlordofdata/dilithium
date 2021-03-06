/**
 *--------------------------------------------------------------------+
 * Boot.dart
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

class Boot extends Phaser.State {

  /**
   * == Boot ==
   *
   *   * Start loading the the splash screen image
   *   * configure the game engine to the environment
   */
  bool orientated = false;
  Config config;

  Boot(Config this.config);

  /**
   * State::preload
   *
   * return	Nothing
   */
  preload() {

    if (config.showSplash)
      if (config.splashKey != null && config.splashImg != null)
        load.image(config.splashKey, config.path+config.splashImg);

    if (config.showPreloadBar) {

      if (config.preloadBarKey != null && config.preloadBarImg != null)
        load.image(config.preloadBarKey, config.path+config.preloadBarImg);

      if (config.preloadBgdKey != null && config.preloadBgdImg != null)
        load.image(config.preloadBgdKey, config.path+config.preloadBgdImg);
    }


  }

  /**
   * State::create
   *
   * return	Nothing
   */
  create() {

    input.maxPointers = 1;
    stage.disableVisibilityChange = true;

    if (game.device.desktop) {

      print("game.device.desktop");
      scale // for desktop:
        ..scaleMode = config.scaleMode
        ..minWidth = config.minWidth
        ..minHeight = config.minHeight
        ..maxWidth = config.maxWidth
        ..maxHeight = config.maxHeight
        ..pageAlignHorizontally = config.pageAlignHorizontally
        ..pageAlignVertically = config.pageAlignVertically
        ..setScreenSize(true);
    } else {

      print("game.device.mobile");
      scale // for mobile:
        ..scaleMode = config.scaleMode
        ..minWidth = config.minWidth
        ..minHeight = config.minHeight
        ..maxWidth = config.maxWidth
        ..maxHeight = config.maxHeight
        ..pageAlignHorizontally = config.pageAlignHorizontally
        ..pageAlignVertically = config.pageAlignVertically
        ..setScreenSize(true);
//        ..setResizeCallback(gameResized)

      print("game.device.mobile2");
      if (config.forceOrientation) {
        scale //
          ..forceOrientation(config.pageAlignHorizontally, config.pageAlignVertically)
          ..enterIncorrectOrientation.add(enterIncorrectOrientation)
          ..leaveIncorrectOrientation.add(leaveIncorrectOrientation);

        }
    }
    // Load the remaining assets
    state.start(config.assets, true, false);
  }

  /**
   * Game Resized
   *
   * return	Nothing
   */
  gameResized(width, height) {}


  /**
   * Enter Incorrect Orientation
   *
   * return	Nothing
   */
  enterIncorrectOrientation() {

    orientated = false;
    querySelector('#orientation').style.display = 'block';
  }

  /**
   * Leave Incorrect Orientation
   *
   * return	Nothing
   */
  leaveIncorrectOrientation() {

    orientated = true;
    querySelector('#orientation').style.display = 'none';
  }
}