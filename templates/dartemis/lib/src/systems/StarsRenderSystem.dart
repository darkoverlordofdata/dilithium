part of orion;


class StarsRenderSystem extends VoidEntitySystem {

  Phaser.Game game;
  Context orion;

  StarsRenderSystem(this.game, this.orion);


  void initialize() {
    print("BackgroundRenderSystem::initialize");
    GroupManager groupManager = world.getManager(new GroupManager().runtimeType);

    ComponentMapper<Sprite> spriteMapper = new ComponentMapper<Sprite>(Sprite, world);
    ComponentMapper<Bounce> bounceMapper = new ComponentMapper<Bounce>(Bounce, world);
    ComponentMapper<Gravity> gravityMapper = new ComponentMapper<Gravity>(Gravity, world);

    //  The platforms group contains the ground and the 2 ledges we can jump on
    Phaser.Group stars = orion.registerStars(game.add.group());

    //  We will enable physics for any object that is created in this group
    stars.enableBody = true;

    groupManager.getEntities(GROUP_STARS).forEach((entity) {

      Sprite sprite = spriteMapper.get(entity);
      Bounce bounce = bounceMapper.get(entity);
      Gravity gravity = gravityMapper.get(entity);

      Phaser.Sprite s = stars.create(sprite.x, sprite.y, sprite.key);
      s.body.bounce.y = bounce.y;
      s.body.gravity.y = gravity.y;

    });
  }

  void processSystem() {
  }
}
