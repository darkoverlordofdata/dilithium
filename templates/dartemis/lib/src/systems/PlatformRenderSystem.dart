part of orion;


class PlatformRenderSystem extends VoidEntitySystem {

  Phaser.Game game;
  Context orion;

  PlatformRenderSystem(this.game, this.orion);


  void initialize() {
    print("BackgroundRenderSystem::initialize");
    GroupManager groupManager = world.getManager(new GroupManager().runtimeType);

    ComponentMapper<Sprite> spriteMapper = new ComponentMapper<Sprite>(Sprite, world);
    ComponentMapper<Scale> scaleMapper = new ComponentMapper<Scale>(Scale, world);
    ComponentMapper<Immovable> immovableMapper = new ComponentMapper<Immovable>(Immovable, world);

    //  The platforms group contains the ground and the 2 ledges we can jump on
    Phaser.Group platforms = orion.registerPlatforms(game.add.group());

    //  We will enable physics for any object that is created in this group
    platforms.enableBody = true;

    groupManager.getEntities(GROUP_PLATFORMS).forEach((entity) {

      Sprite sprite = spriteMapper.get(entity);
      Scale scale = scaleMapper.get(entity);
      Immovable immovable = immovableMapper.get(entity);

      Phaser.Sprite s = platforms.create(sprite.x, sprite.y, sprite.key);
      s.scale.set(scale.x, scale.y);
      s.body.immovable = immovable.value;

    });
  }

  void processSystem() {
  }
}
