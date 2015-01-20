/**
 *--------------------------------------------------------------------+
 * Game.dart
 *--------------------------------------------------------------------+
 * Copyright {{project.author}} (c) {{project.copyright}}
 *--------------------------------------------------------------------+
 *
 * This file is a part of {{ project.libname }}
 *
 * {{ project.libname }} is free software; you can copy, modify, and distribute
 * it under the terms of the {{ project.license }}
 *
 *--------------------------------------------------------------------+
 *
 */
part of {{ project.libname }};

class Game  extends Li2.Dilithium {

  Li2.Template template;

  Game(config, this.template): super(config) {
  }

  /**
   * Define each of the game states
   */
  Phaser.State levels() {
    return new Menu(config);

  }

}
