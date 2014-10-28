part of orion;

class PlayerControlSystem extends IntervalEntitySystem {

  Phaser.Game game;
  Context orion;
  Phaser.Sprite playerSprite;
  var cursors;

  PlayerControlSystem(this.game, this.orion)
    : super(20, Aspect.getAspectForAllOf([Velocity, Bounce, Gravity, Animation, Sprite]));

  void initialize() {
    print("PlayerControlSystem::initialize");
    //  Our controls.
    cursors = game.input.keyboard.createCursorKeys();
    var velocityMapper = new ComponentMapper<Velocity>(Velocity, world);
    var bounceMapper = new ComponentMapper<Bounce>(Bounce, world);
    var gravityMapper = new ComponentMapper<Gravity>(Gravity, world);
    var animationMapper = new ComponentMapper<Animation>(Animation, world);
    var spriteMapper = new ComponentMapper<Sprite>(Sprite, world);

    TagManager tagManager = world.getManager(TagManager);
    Entity player = tagManager.getEntity(TAG_PLAYER);
    Velocity velocity = velocityMapper.get(player);
    Bounce bounce = bounceMapper.get(player);
    Gravity gravity = gravityMapper.get(player);
    Animation animation = animationMapper.get(player);
    Sprite sprite = spriteMapper.get(player);

    playerSprite = game.add.sprite(sprite.x, sprite.y, sprite.key);
    orion.registerPlayer(playerSprite);

    //  We need to enable physics on the player
    game.physics.arcade.enable(playerSprite);

    playerSprite
      ..body.bounce.y = bounce.y
      ..body.gravity.y = gravity.y
      ..body.collideWorldBounds = true;

    animation.cells.forEach((name, v) {
      playerSprite.animations.add(name, v['frames'], v['frameRate'], v['loop'], v['useNumericIndex']);
    });
  }

  /**
   * This is where all of the player activities occur
   */
  void processEntities(Iterable<Entity> entities) {

    playerSprite.body.velocity.x = 0;

    if (cursors.left.isDown){
      //  Move to the left
      playerSprite.body.velocity.x = -150;

      playerSprite.animations.play('left');
    } else if (cursors.right.isDown) {
      //  Move to the right
      playerSprite.body.velocity.x = 150;

      playerSprite.animations.play('right');
    } else {
      //  Stand still
      playerSprite.animations.stop();

      playerSprite.frame = 4;
    }

    //  Allow the player to jump if they are touching the ground.
    if (cursors.up.isDown && playerSprite.body.touching.down) {
//    if (cursors.up.isDown) {
      print(playerSprite.body.touching.down);
      playerSprite.body.velocity.y = -350;
    }

  }

}
