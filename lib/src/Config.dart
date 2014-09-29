/*+--------------------------------------------------------------------+
#| Config.dart
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Load the game assets
*/
part of dilithium;

class Config {

  String path = "";
  String name = "name";
  String boot = "__boot";
  String assets = "__assets";
  String menu = "__menu";
  String creditsText = "";
  String copyrightText = "Copyright 2014 Dark Overlord of Data";
  bool debug = false;

  int renderer = AUTO;
  int width = 320;
  int height = 480;
  int minWidth = 320;
  int minHeight = 480;
  int maxWidth = 640;
  int maxHeight = 960;
  bool pageAlignHorizontally = true;
  bool pageAlignVertically = true;
  bool forceOrientation = false;

  String splashKey = 'splashScreen';
  String splashImg = '';

  bool showPreloadBar = false;
  String preloadBarKey = 'preloadBar';
  String preloadBarImg = '';
  String preloadBgdKey = 'preloadBgd';
  String preloadBgdImg = '';

  var images = {};
  var sprites = {};
  var levels = {};

  String source;
  cordova.Device device;

  /**
   * Load configuration
   *
   * @param source  yaml configuration string
   * @param path    base asset path
   */
  Config(String this.source, String this.path) {

    print("Class Config initialized");

    if (path != "")
      if (!path.endsWith("/"))
        path += "/";

    var raw = loadYaml(source);

    this
      ..name = raw['name']
      ..minWidth = raw['minWidth']
      ..minHeight = raw['minHeight']
      ..maxWidth = raw['maxWidth']
      ..maxHeight = raw['maxHeight']
      ..pageAlignHorizontally = raw['pageAlignHorizontally']
      ..pageAlignVertically = raw['pageAlignVertically']
      ..forceOrientation = raw['forceOrientation']
      ..splashKey = raw['splashKey']
      ..splashImg = raw['splashImg']
      ..showPreloadBar = raw['showPreloadBar']
      ..preloadBarKey = raw['preloadBarKey']
      ..preloadBarImg = raw['preloadBarImg']
      ..preloadBgdKey = raw['preloadBgdKey']
      ..preloadBgdImg = raw['preloadBgdImg']
      ..images = raw['images']
      ..sprites = raw['sprites']
      ..levels = raw['levels']
      ..creditsText = raw['creditsText']
      ..copyrightText = raw['copyrightText'];

  }

}
