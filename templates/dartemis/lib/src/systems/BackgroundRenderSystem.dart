part of orion;


class BackgroundRenderSystem extends VoidEntitySystem {

  Phaser.Game game;
  Context orion;

  BackgroundRenderSystem(this.game, this.orion);


  void initialize() {
    print("BackgroundRenderSystem::initialize");
    GroupManager groupManager = world.getManager(new GroupManager().runtimeType);
    ComponentMapper<Sprite> spriteMapper = new ComponentMapper<Sprite>(Sprite, world);

    groupManager.getEntities(GROUP_BACKGROUND).forEach((entity) {
      Sprite sprite = spriteMapper.get(entity);
      game.add.sprite(sprite.x, sprite.y, sprite.key);
    });
  }

  void processSystem() {
  }
}
