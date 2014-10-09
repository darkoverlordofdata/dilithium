/**
 +--------------------------------------------------------------------+
 | Main.dart
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

/**
 * == Start ==
 *
 *   * Check if running with cordova
 *   * Start a game
 */
void start() {
  if (context['cordova'] != null) {
    cordova.Device.init()
    .then((device) => startGame(device))
    .catchError((ex, st) {
      print(ex);
      print(st);
      startGame(null);
    });
  }
  else startGame(null);
}


/**
 * == start game ==
 *
 *   * Hide the logo
 *   * Using game configuration
 *   * Start a game instance
 */
void startGame(device) {

  Dilithium.using("packages/{{ project.libname }}").then((config) {
    querySelector('#logo').style.display = 'none';
    querySelector('body').style.backgroundColor = 'black';
    Game game = new {{ project.name }}(config, device);
  });

}