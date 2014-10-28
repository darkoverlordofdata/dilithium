/**
 *--------------------------------------------------------------------+
 * GameOver.dart
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

class GameOver extends Li2State {

  /**
   * == Game Over ==
   *   * Show the splash screen
   *   * Play again?
   */

  Button startButton;
  Li2Config config;

  GameOver(Li2Config this.config);

  /**
   * State::create
   *
   * @return	Nothing
   */
  create() {


    // game over message
    TextStyle style = new TextStyle(
        font      : "bold 30px Acme",
        fill      : "#e22",
        align     : "center"
    );
    Text gameOver = add.text(0, 0, "Game Over", style);
    gameOver.fixedToCamera = true;
    gameOver.cameraOffset.setTo(0, 0);
    startButton = add.button(world.centerX - 95, 350, 'startButton', startGame, this);

  }


  /**
   * Start Game
   *
   * @return	Nothing
   */
  startGame(source, input, flag) {
    state.start("Level1");
  }
}