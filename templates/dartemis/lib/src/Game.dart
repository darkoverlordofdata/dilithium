part of orion;

class Game extends Phaser.State {

  World artemis;
  Context orion;

  /**
   * Create new Game
   */
  Game() {
    new Phaser.Game(800, 600, Phaser.AUTO, '', this);
  }

  /**
   * Preload the assets
   */
  preload() {
    game.load.image('sky', 'assets/sky.png');
    game.load.image('ground', 'assets/platform.png');
    game.load.image('star', 'assets/star.png');
    game.load.spritesheet('orion', 'assets/dude.png', 32, 48);
  }

  /**
   * Create the game world
   */
  create() {
    artemis = new World();
    EntityFactory build = new EntityFactory(game, artemis);

    /**
     * Build the entities
     */
    build.background(0, 0, 'sky');
    build.platform(0, world.height - 64, 'ground', 2);
    build.platform(400, 400, 'ground');
    build.platform(-159, 250, 'ground');
    build.player(32, world.height - 150, 'orion', {
        'left': {
            'frames': [0, 1, 2, 3],
            'frameRate': 10,
            'loop': true,
            'useNumericIndex': true
        },
        'right': {
            'frames': [5, 6, 7, 8],
            'frameRate': 10,
            'loop': true,
            'useNumericIndex': true
        }
    });
    for (int i = 0; i < 12; i++) {
      build.star(i, 0, 'star');
    }
    build.score(16, 16, 'Score: ', 'bold 20pt Arial', '#000');

    /**
     * Install systems and start
     */
    orion = new Context();
    artemis
      ..addSystem(new ArcadePhysicsSystem(game, orion))
      ..addSystem(new BackgroundRenderSystem(game, orion))
      ..addSystem(new PlatformRenderSystem(game, orion))
      ..addSystem(new PlayerControlSystem(game, orion))
      ..addSystem(new StarsRenderSystem(game, orion))
      ..addSystem(new ScoreRenderSystem(game, orion))
      ..initialize();

  }

  /**
   * Game Loop
   */
  update() {
    artemis.delta = game.time.elapsed;
    artemis.process();
  }

}

