part of orion;

const String GROUP_BACKGROUND = "BACKGROUND";
const String GROUP_PLATFORMS  = "PLATFORMS";
const String GROUP_STARS      = "STARS";
const String TAG_PLAYER       = "PLAYER";
const String TAG_SCORE        = "SCORE";


class EntityBase {

  Phaser.Game game;
  World world;
  GroupManager groupManager;
  TagManager tagManager;

  EntityBase(this.game, this.world) {
    
    tagManager = new TagManager();
    world.addManager(tagManager);

    groupManager = new GroupManager();
    world.addManager(groupManager);

  }

}

class EntityFactory extends EntityBase {

  EntityFactory(game, world) : super(game, world);

  void background(int x, int y, String key) {
    Entity background = world.createEntity();
    background.addComponent(new Sprite(x, y, key));
    groupManager.add(background, GROUP_BACKGROUND);
  }

  void platform(int x, int y, String key, [int scale = 1]) {
    Entity ground = world.createEntity();
    ground
      ..addComponent(new Sprite(x, y, key))
      ..addComponent(new Scale(scale, scale))
      ..addComponent(new Immovable(true))
      ..addToWorld();
    groupManager.add(ground, GROUP_PLATFORMS);
  }

  void star(int x, int y, String key) {
    Entity star = world.createEntity();
    star
      ..addComponent(new Sprite(x * 70, y, key))
      ..addComponent(new Gravity(0, 300))
      ..addComponent(new Bounce(0, 0.7 + game.rnd.normal() * 0.2))
      ..addToWorld();
    groupManager.add(star, GROUP_STARS);

  }

  void player(int x, int y, String key, Map cells) {
    Entity player = world.createEntity();
    player
      ..addComponent(new Sprite(x, y, key))
      ..addComponent(new Velocity(0, 0))
      ..addComponent(new Gravity(0, 300))
      ..addComponent(new Bounce(0, .2))
      ..addComponent(new Animation(cells))
      ..addToWorld();
    tagManager.register(player, TAG_PLAYER);

  }

  void score(int x, int y, String text, String font, String fill) {
    Entity score = world.createEntity();
    score
      ..addComponent(new Position(x, y))
      ..addComponent(new Text(text, font, fill))
      ..addComponent(new Count(0))
      ..addToWorld();
    tagManager.register(score, TAG_SCORE);
  }

}