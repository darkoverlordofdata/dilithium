/**
 +--------------------------------------------------------------------+
 | Levels.dart
 +--------------------------------------------------------------------+
 | Copyright DarkOverlordOfData (c) 2014
 +--------------------------------------------------------------------+
 |
 | This file is a part of {{ project.libname }}
 |
 | {{ project.libname }} is free software; you can copy, modify, and distribute
 | it under the terms of the {{ project.license }}
 |
 +--------------------------------------------------------------------+

    {{ project.name }}

    {{ project.description }}
 
 */
part of {{ project.libname }};

class Levels extends State {

  /**
   * Members
   */
  Random rnd = new Random();
  Sprite background;
  Sprite startButton;
  Text text;
  int score = 0;

  Config config;

  Levels(Config this.config);

  /**
   * == Create the game level
   *   * set the background and game board
   *   * draw the text
   *   * wire up the buttons
   *
   * return none
   */
  create() {

    time.advancedTiming = true;
    score = 0;
    background = add.sprite(0, 0, 'background');

    text = add.text(100, 20, "Score: 0", new TextStyle(font: "bold 30px Acme",fill: "#e0e0e0"));
  }
  

  goBack(source, input, flag) {
    state.start(config.menu);
  }


  /**
   * Game Over
   *
   * return none
   */
  gameOver() {
    state.start("GameOver", false, false);
  }

}