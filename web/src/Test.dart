part of example;

class Test extends BaseGame {

  cordova.Device device;

  Test(config, this.device) : super(config) {
  }

  create() {
    super.create();
    game.state.add(config.menu, new Demo(this.config));
    game.state.start(config.boot);
  }
}
