/**
 *--------------------------------------------------------------------+
 * Config.dart
 *--------------------------------------------------------------------+
 * Copyright DarkOverlordOfData (c) 2014
 *--------------------------------------------------------------------+
 *
 * This file is a part of dilithium
 *
 * dilithium is free software; you can copy, modify, and distribute
 * it under the terms of the MIT License
 *
 *--------------------------------------------------------------------+
 *
 */
part of dilithium;

class Config {

  static const String DELIM_ARRAY  = 'array/';
  static const String DELIM_STRING = 'string/';

  String path = "";
  String name = "name";
  String boot = "__boot";
  String assets = "__assets";
  String menu = "__menu";
  bool debug = false;
  bool locale = false;
  bool transparent = true;

  String id = '';
  int renderer = Phaser.CANVAS; // Force Canvas for Mobile
  int width = 320;
  int height = 480;
  int minWidth = 320;
  int minHeight = 480;
  int maxWidth = 640;
  int maxHeight = 960;
  int scaleMode = Phaser.ScaleManager.SHOW_ALL;
  bool pageAlignHorizontally = true;
  bool pageAlignVertically = true;
  bool forceOrientation = false;

  String orientation = '';
  bool showSplash = false;
  String splashKey = 'splashScreen';
  String splashImg = '';

  bool showPreloadBar = false;
  String preloadBarKey = 'preloadBar';
  String preloadBarImg = '';
  String preloadBgdKey = 'preloadBgd';
  String preloadBgdImg = '';

  var paths = {};
  var sections = {};

  var audio = {};
  var images = {};
  var sprites = {};
  var tilemaps = {};
  var levels = {};
  var strings = {};
  var arrays = {};
  var preferences = {};
  var extra = {};

  String source;
//  var device;

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


    if (raw['boot'] != null)
      this.boot = raw['boot'];
    if (raw['assets'] != null)
      this.assets = raw['assets'];
    if (raw['menu'] != null)
      this.menu = raw['menu'];

    if (raw['id'] != null)
      this.id = raw['id'];

    showSplash = raw['showSplash'];
    transparent = raw['transparent'];
    locale = raw['locale'];

    name = raw['name'];
    paths = raw['paths'];
    width = raw['minWidth'];
    height = raw['minHeight'];
    minWidth = raw['minWidth'];
    minHeight = raw['minHeight'];
    maxWidth = raw['maxWidth'];
    maxHeight = raw['maxHeight'];
    scaleMode = raw['scaleMode'];
    pageAlignHorizontally = raw['pageAlignHorizontally'];
    pageAlignVertically = raw['pageAlignVertically'];
    forceOrientation = raw['forceOrientation'];
    orientation = raw['orientation'];
    splashKey = raw['splashKey'];
    splashImg = raw['splashImg'];
    showPreloadBar = raw['showPreloadBar'];
    preloadBarKey = raw['preloadBarKey'];
    preloadBarImg = raw['preloadBarImg'];
    preloadBgdKey = raw['preloadBgdKey'];
    preloadBgdImg = raw['preloadBgdImg'];
    sections = raw['sections'];
    audio = raw['audio'];
    images = raw['images'];
    sprites = raw['sprites'];
    tilemaps = raw['tilemaps'];
    levels = raw['levels'];
    strings = raw['strings'];
    strings = raw['arrays'];
    strings = raw['preferences'];
    extra = raw['extra'];

  }

  /**
   * Load optional config hives, such as from res/values/strings.yaml
   */
  setSection(String name, String source) {
    switch(name) {
      case 'audio':
        try {
          audio = loadYaml(source);
        } catch (e) {}
        break;
      case 'images':
        try {
          images = loadYaml(source);
        } catch (e) {}
        break;
      case 'sprites':
        try {
          sprites = loadYaml(source);
        } catch (e) {}
        break;
      case 'tilemaps':
        try {
          tilemaps = loadYaml(source);
        } catch (e) {}
        break;
      case 'levels':
        try {
          levels = loadYaml(source);
        } catch (e) {}
        break;
      case 'strings':
        try {
          strings = loadYaml(source);
        } catch (e) {}
        break;
      case 'arrays':
        try {
          loadYaml(source).forEach((key, values) {
            arrays[key] = new List();
            for (var i=0; i<values.length; i++) {
              String str = values[i];
              arrays[key].add(xlate(values[i]));
            }
          });
        } catch (e) {}
        break;
      case 'preferences':
        try {
          preferences = loadYaml(source);
        } catch (e) {}
        break;
      case 'extra':
        try {
          extra = loadYaml(source);
        } catch (e) {}
        break;

    }
  }

  /**
   * Translate string value
   */
  xlate(value) {
    if (value is String) {
      if (value.startsWith('string/')) {
        value = strings[value.replaceAll(DELIM_STRING, '')];
      }
      else if (value.startsWith('array/')) {
        value = arrays[value.replaceAll(DELIM_ARRAY, '')];
      }
    }
    return value;
  }


}
