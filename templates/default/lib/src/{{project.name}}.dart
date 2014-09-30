/**
 +--------------------------------------------------------------------+
 | {{ project.name }}.dart
 +--------------------------------------------------------------------+
 | Copyright DarkOverlordOfData (c) 2014
 +--------------------------------------------------------------------+
 |
 | This file is a part of {{ project.libname }}
 |
 | {{ project.libname }} is free software; you can copy, modify, and distribute
 | it under the terms of the {{ project.license }}
 |
 +--------------------------------------------------------------------+

    {{ project.name }}

    {{ project.description }}

 */
part of {{ project.libname }};

class {{ project.name }}  extends Dilithium {

  cordova.Device device;

  /**
   * == New Game ==
   *   * Set the screen dimensions
   *   * Configure the game states
   *   * Start the game
   *
   * returns this
   */
  {{ project.name }}(config, this.device): super(config) {

    print("Class {{ project.name }} initialized");
  }

  create() {

    super.create();
    game.state
      ..add(config.menu,  new Menu(config))
      ..add('Levels',     new Levels(config))
      ..add('Credits',    new Credits(config))
      ..add('Scores',     new Scores(config))
      ..add('GameOver',   new GameOver(config))
      ..start(config.boot);

  }

}