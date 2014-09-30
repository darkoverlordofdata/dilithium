part of example;

class Test extends Dilithium {

  Test(config) : super(config);

  create() {
    super.create();
    game.state.add(config.menu, new Demo(this.config));
    game.state.start(config.boot);
  }
}
