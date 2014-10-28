part of orion;
/**
 * The game
 */

class Context {

  int _score = 0;
  Phaser.Sprite player = null;
  Phaser.Group platforms = null;
  Phaser.Group stars = null;
  ScoreRenderSystem scoreListener = null;


  /**
   * Game Score
   */
  int get score => _score;

  set score(int value) {
    _score = value;
    scoreListener.update(_score);

  }

  /**
   * register the Score listener
   */
  void registerScoreListener(ScoreRenderSystem scoreListener) {
    this.scoreListener = scoreListener;
  }

  /**
   * register the Phaser player
   */
  Phaser.Sprite registerPlayer(Phaser.Sprite player) {
    this.player = player;
    return player;
  }

  /**
   * register the Phaser platforms
   */
  Phaser.Group registerPlatforms(Phaser.Group platforms) {
    this.platforms = platforms;
    return platforms;
  }

  /**
   * register the Phaser stars
   */
  Phaser.Group registerStars(Phaser.Group stars) {
    this.stars = stars;
    return stars;
  }

}

