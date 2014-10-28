/**
 *--------------------------------------------------------------------+
 * Menu.dart
 *--------------------------------------------------------------------+
 * Copyright {{project.author}} (c) {{project.copyright}}
 *--------------------------------------------------------------------+
 *
 * This file is a part of {{ project.libname }}
 *
 * {{ project.libname }} is free software; you can copy, modify, and distribute
 * it under the terms of the {{ project.license }}
 *
 *--------------------------------------------------------------------+
 *
 */
part of {{ project.libname }};

class Menu extends Li2State {

  /**
   * == Menu ==
   *   * Show the splash screen
   *   * Show the main menu selections
   */

  Li2Config config;

  Menu(Li2Config this.config);

  /**
   * State::create
   *
   * return	Nothing
   */
  create() {
    add // ui components
      ..sprite(0, 0, config.splashKey)
      ..button(100, 160, 'playButton', startGame, this)
      ..button(100, 200, 'creditsButton', showCredits, this)
      ..button(100, 240, 'scoreButton', showScores, this);

  }


  /**
   * Start Game
   *
   * return	Nothing
   */
  startGame(source, input, flag) {
    state.start("Levels", true, false);
  }

  /**
   * Show Credits
   *
   * return	Nothing
   */
  showCredits(source, input, flag) {
    state.start("Credits", true, false);
  }

  /**
   * Show Scores
   *
   * return	Nothing
   */
  showScores(source, input, flag) {
    state.start("Scores", true, false);
  }


}