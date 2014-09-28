/*+--------------------------------------------------------------------+
#| Boot.dart
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of lore
#|
#| lore is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Lore
#
#   Game Template
*/
part of dilithium;

class Boot extends State {

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

    load.image(config.splashKey, config.splashImg);
    if (config.showPreloadBar) {
      load.image(config.preloadBarKey, config.preloadBarImg);
      load.image(config.preloadBgdKey, config.preloadBgdImg);
    }


  }

  /**
   * State::create
   *
   * return	Nothing
   */
  create() {

    print("Class Start::create");
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