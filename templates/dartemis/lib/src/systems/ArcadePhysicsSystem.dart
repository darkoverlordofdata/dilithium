part of orion;

class ArcadePhysicsSystem extends VoidEntitySystem {

  Phaser.Game game;
  Context orion;
  Arcade.Arcade arcade;

  ArcadePhysicsSystem(this.game, this.orion) {
    print("ArcadePhysicsSystem: started");
    game.physics.startSystem(Phaser.Physics.ARCADE);
    arcade = game.physics.arcade;

  }

  /**
   * Do the collision checks
   */
  void processSystem() {

    //  Collide the player and the stars with the platforms
    arcade.collide(orion.player, orion.platforms);
    arcade.collide(orion.stars, orion.platforms);

    //  Checks to see if the player overlaps with any of the stars, if he does call the collectStar function
    arcade.overlap(orion.player, orion.stars, collectStar, null);

  }

  /**
   * Collect Star's to Win!
   */
  collectStar(playerSprite, star) {
    // Removes the star from the screen
    star.kill();
    //  Add and update the score
    orion.score += 10;

  }

}

