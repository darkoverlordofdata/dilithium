/*+--------------------------------------------------------------------+
#| Li2Boot.dart
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
# Dilithium
#
#   Game Template
*/
part of dilithium;

class Li2Boot extends State {

  /**
   * == Boot ==
   *
   *   * Start loading the the splash screen image
   *   * configure the game engine to the environment
   */
  bool orientated = false;
  Li2Config config;

  Li2Boot(Li2Config this.config);

  /**
   * State::preload
   *
   * return	Nothing
   */
  preload() {

    load.image(config.splashKey, config.path+config.splashImg);
    if (config.showPreloadBar) {
      load.image(config.preloadBarKey, config.path+config.preloadBarImg);
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

      scale // for desktop:
        ..scaleMode = ScaleManager.SHOW_ALL
        ..minWidth = config.minWidth
        ..minHeight = config.minHeight
        ..maxWidth = config.maxWidth
        ..maxHeight = config.maxHeight
        ..pageAlignHorizontally = config.pageAlignHorizontally
        ..pageAlignVertically = config.pageAlignVertically
        ..setScreenSize(true);
    } else {

      scale // for mobile:
        ..scaleMode = ScaleManager.SHOW_ALL
        ..minWidth = config.minWidth
        ..minHeight = config.minHeight
        ..maxWidth = config.maxWidth
        ..maxHeight = config.maxHeight
        ..pageAlignHorizontally = config.pageAlignHorizontally
        ..pageAlignVertically = config.pageAlignVertically
        ..forceOrientation(config.forceOrientation)
        ..hasResized.add(gameResized, this)
        ..setScreenSize(true);

      if (config.forceOrientation) {
        scale //
          ..enterIncorrectOrientation.add(enterIncorrectOrientation, this)
          ..leaveIncorrectOrientation.add(leaveIncorrectOrientation, this);

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