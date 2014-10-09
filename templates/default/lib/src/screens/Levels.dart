/**
 *--------------------------------------------------------------------+
 * Levels.dart
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

class Levels extends Li2State {

  /**
   * Members
   */
  Random rnd = new Random();
  Sprite background;
  Sprite board;
  Grid grid;
  Sprite startButton;
  Text text;
  List discoveredGems;
  GemGroup gemGroup;
  int score = 0;

  Li2Config config;

  Levels(Li2Config this.config);

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
    board = add.sprite(0, 0, 'board');
    board.alpha = 0.7;

    text = add.text(100, 20, "Score: 0", new TextStyle(font: "bold 30px Acme",fill: "#e0e0e0"));
    grid = new Grid(width: 6, height: 7, gravity: 'down');
    discoveredGems = [Game.GEMTYPES[0], Game.GEMTYPES[1], Game.GEMTYPES[2]];

    newGemGroup();
    add // ui components
      ..button(260,  20, 'backButton',  goBack,       this)
      ..button(  0, 420, 'arrow_left',  leftButton,   this)
      ..button( 50, 420, 'arrow_down',  dropButton,   this)
      ..button(100, 420, 'arrow_right', rightButton,  this)
      ..button(210, 420, 'arrow_lrot',  lrotButton,   this)
      ..button(260, 420, 'arrow_rrot',  rrotButton,   this);
  }
  
  /**
   * Directional Handlers
   *
   * return none
   */
  leftButton(source, input, flag) {
    gemGroup.move(-1);
  }
  
    
  rightButton(source, input, flag) {
    gemGroup.move(1);
  }
    
  lrotButton(source, input, flag) {
    gemGroup.rotate(-1);
  }
    
  rrotButton(source, input, flag) {
    gemGroup.rotate(1);
  }
    
  dropButton(source, input, flag) {
    gemGroup.drop();
    gemGroup = null;
  }

  goBack(source, input, flag) {
    state.start(config.menu);
  }

  /**
   * New Gem Group
   *
   * return Gem Group
   */
  newGemGroup() {
    gemGroup = new GemGroup(this);
  }

  /**
   * Handle Matches
   *
   * return none
   */
  handleMatches() {

    var piecesToUpgrade;
    // Get all matches
    // If matches have been found
    var matches = grid.getMatches();
    if (matches != null) {
      // Initialize the array of pieces to upgrade
      piecesToUpgrade = [];
      // Reference to the current game
      // For each match found
      grid.forEachMatch((matchingPieces, type) {
        // Add to score
        addToScore((Game.GEMTYPES.indexOf(type) + 1) * matchingPieces.length, "#ff0", matchingPieces[0].x, matchingPieces[0].y);
        // For each match take the first piece to upgrade it
        piecesToUpgrade.add({
          'piece'   : matchingPieces[0],
          'type'    : type
        });
        matchingPieces.forEach((matchingPiece) {
          // Destroy each piece
          add.tween(matchingPiece.object.sprite)
          .repeat(6)
          .to({'alpha':0}, 150, Easing.Linear.None, true, 0, 0, true)
          .onComplete.add((Sprite s) => s.destroy());
        });
      });

      // Remove matches and apply Gravity
      grid.clearMatches();
      // Upgrade pieces
      handleUpgrade(piecesToUpgrade);
    }
    handleFalling();
  }

  /**
   ^ Handle Falling
   ^
   ^ return none
   */
  handleFalling() {

    // Apply gravity and get falling Pieces
    var fallingPieces = grid.applyGravity();
    var hasFall;

    if (fallingPieces.length > 0) {
      // Falling counter
      hasFall = 0;
      // For each falling pieces
      fallingPieces.forEach((piece) {
        piece.object.fall(piece.x, piece.y, (Sprite s) {
          hasFall += 1;
          if (hasFall == fallingPieces.length)
            handleMatches();
        });
      });
    } else {
      // Create a new gem if no falling pieces
      newGemGroup();
    }
  }
  /**
   * Handle Upgrade
   *
   * return none
  */
  handleUpgrade(piecesToUpgrade) {

    // For each piece to upgrade
    piecesToUpgrade.forEach((pieceToUpgrade) {
      // Get the upgraded type
      var upgradedType = Game.GEMTYPES[Game.GEMTYPES.indexOf(pieceToUpgrade['type']) + 1];
      // If the type is defined
      if (upgradedType != null) {
        // And if the type is not already discovered
        if (discoveredGems.indexOf(upgradedType) == -1)
          // Push it to discovered gems array
          discoveredGems.add(upgradedType);
      }
    });
  }

  /**
   * Random Gem Type
   *
   * return string - random gem type
   */
  randomGemType() {

    var i = rnd.integerInRange(0, discoveredGems.length-1);
    return discoveredGems[i];
  }

  /**
   * Add to Score
   *
   * return none
   */
  addToScore(int points, String color, int x, int y) {

    int speed = 1000;
    var dur = const Duration(milliseconds: 1000);
    var scoreStyle = new TextStyle(font: "bold 40px Courier New, Courier",fill: color, align: "center");


    score += points;
    text.text = "Score: $score";
    text.updateText();

    Text popup = add.text(150, 300, "$points", scoreStyle);
    add.tween(popup)
    .to({'alpha': 1}, speed*0.75, Easing.Linear.None, true)
    .to({'alpha': 0}, speed*0.25, Easing.Linear.None, true);

    new async.Timer(dur, ()=> world.remove(popup));
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