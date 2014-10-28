part of orion;


class ScoreRenderSystem extends VoidEntitySystem {

  Phaser.Game game;
  Context orion;
  Text text;
  Count score;
  Phaser.Text scoreText;

  ScoreRenderSystem(this.game, this.orion);

  void initialize() {
    print("BackgroundRenderSystem::initialize");
    GroupManager groupManager = world.getManager(new GroupManager().runtimeType);
    ComponentMapper<Position> positionMapper = new ComponentMapper<Position>(Position, world);
    ComponentMapper<Count> countMapper = new ComponentMapper<Count>(Count, world);
    ComponentMapper<Text> textMapper = new ComponentMapper<Text>(Text, world);

    TagManager tagManager = world.getManager(TagManager);
    Entity entity = tagManager.getEntity(TAG_SCORE);

    Position position = positionMapper.get(entity);
    text = textMapper.get(entity);
    score = countMapper.get(entity);
    var style = new Phaser.TextStyle(font: text.font, fill: text.fill);
    scoreText = game.add.text(position.x, position.y, "${text.value}: 0", style);
    orion.registerScoreListener(this);
  }

  /**
   * Update the score
   */
  void update(int score) {
    scoreText.text = "${text.value} ${score}";
    scoreText.updateText();

  }

  void processSystem() {

  }
}
