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

  var paths = {};
  var images = {};
  var sprites = {};
  var levels = {};
  var strings = {};
  var arrays = {};
  var preferences = [];

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
      ..paths = raw['paths']
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
      ..strings = raw['strings'];

  }

  /**
   * Load localized strings from res/values/strings.yaml
   */
  setStrings(String source) {
    strings = loadYaml(source);
  }

  /**
   * Load preferences from res/preferences.yaml
   */
  setPreferences(String source) {
    loadYaml(source).forEach((category) {
      preferences.add({
          'title':  xlate(category['title']),
          'fields': (List fields) {
            List result = [];
            fields.forEach((preference) {
              result.add({
                  'key':            preference['key'],
                  'type':           preference['type'],
                  'title':          xlate(preference['title']),
                  'defaultValue':   xlate(preference['defaultValue']),
                  'summary':        xlate(preference['summary'])
              });
            });
            return result;
          }(category['fields'])
      });
    });
  }

  /**
   * Load arrays from res/values/arrays.yaml
   */
  setArrays(String source) {
    loadYaml(source).forEach((key, values) {
      arrays[key] = new List();
      for (var i=0; i<values.length; i++) {
        String str = values[i];
        arrays[key].add(xlate(values[i]));
      }
    });
  }

  /**
   * Translate string value
   */
  xlate(value) {
    if (value is String) {
      if (value.startsWith('string/')) {
        value = strings[value.replaceAll('string/', '')];
      }
    }
    return value;
  }


}
