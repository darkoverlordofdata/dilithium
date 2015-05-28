
/*
           ___ ___ __  __    _
      ____/ (_) (_) /_/ /_  (_)_  ______ ___
     / __  / / / / __/ __ \/ / / / / __ `__ \
    / /_/ / / / / /_/ / / / / /_/ / / / / / /
    \__,_/_/_/_/\__/_/ /_/_/\__,_/_/ /_/ /_/



Copyright (c) 2014 Bruce Davidson <darkoverlordofdata@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

(function() {
  'use strict';
  var Assets, Boot, Config, Dilithium, Template, li2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  li2 = {};

  li2.Assets = Assets = (function(_super) {
    __extends(Assets, _super);

    Assets.prototype.preloadBar = null;

    Assets.prototype.preloadBgd = null;

    Assets.prototype.config = {};

    function Assets(config) {
      this.config = config;
    }

    Assets.prototype.preload = function() {
      var k, key, level, levelName, preloadBar, preloadBgd, sprite, v, _ref, _ref1, _ref2, _ref3;
      console.log("Class Assets initializing");
      if (this.config.showSplash) {
        this.load.setPreloadSprite(this.add.sprite(0, 0, this.config.splashKey));
      }
      if (this.config.showPreloadBar) {
        preloadBgd = this.add.sprite(config.width * 0.5, config.height * 0.5, this.config.preloadBgdKey);
        preloadBgd.anchor.setTo(0.5, 0.5);
        preloadBar = this.add.sprite(config.width * 0.5, config.height * 0.75, this.config.preloadBarKey);
        preloadBar.anchor.setTo(0.5, 0.5);
        this.load.setPreloadSprite(preloadBar);
      }
      if (this.config.audio) {
        _ref = this.config.audio;
        for (k in _ref) {
          v = _ref[k];
          this.load.audio(k, this.config.path + v);
        }
      }
      if (this.config.images) {
        _ref1 = this.config.images;
        for (k in _ref1) {
          v = _ref1[k];
          this.load.image(k, this.config.path + v);
        }
      }
      if (this.config.tilemaps) {
        _ref2 = this.config.tilemaps;
        for (k in _ref2) {
          level = _ref2[k];
          levelName = level.options.map;
          this.load.tilemap(levelName, this.config.path + ("levels/" + levelName.json), null, Phaser.Tilemap.TILED_JSON);
        }
      }
      if (this.config.sprites) {
        _ref3 = this.config.sprites;
        for (key in _ref3) {
          sprite = _ref3[key];
          if ('string' === typeof sprite.file) {
            this.load.spritesheet(key, this.config.path + sprite.file, sprite.width, sprite.height);
          } else {
            if (sprite['selected'] === true) {
              this.load.spritesheet(key, this.config.path + sprite.file[sprite.selected], sprite.width, sprite.height);
            }
            sprite.file.forEach((function(_this) {
              return function(file, ix) {
                return _this.load.spritesheet("" + key + "[" + ix + "]", _this.config.path + file, sprite.width, sprite.height);
              };
            })(this));
          }
        }
      }
    };

    Assets.prototype.create = function() {
      return this.state.start(this.config.menu, true, false);
    };

    return Assets;

  })(Phaser.State);

  li2.Boot = Boot = (function(_super) {
    __extends(Boot, _super);

    Boot.prototype.orientated = false;

    Boot.prototype.config = {};

    function Boot(config) {
      this.config = config;
    }

    Boot.prototype.preload = function() {
      if (this.config.splashKey !== '') {
        this.load.image(this.config.splashKey, this.config.path + this.config.splashImg);
      }
      if (this.config.preloadBarKey !== '') {
        this.load.image(this.config.preloadBarKey, this.config.path + this.config.preloadBarImg);
        return this.load.image(this.config.preloadBgdKey, this.config.path + this.config.preloadBgdImg);
      }
    };

    Boot.prototype.create = function() {
      this.input.maxPointers = 1;
      this.stage.disableVisibilityChange = true;
      if (this.game.device.desktop) {
        this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
        this.scale.minWidth = this.config.minWidth;
        this.scale.minHeight = this.config.minHeight;
        this.scale.maxWidth = this.config.maxWidth;
        this.scale.maxHeight = this.config.maxHeight;
        this.scale.pageAlignHorizontally = this.config.pageAlignHorizontally;
        this.scale.pageAlignVertically = this.config.pageAlignVertically;
        this.scale.setScreenSize(true);
      } else {
        this.scale.scaleMode = Phaser.ScaleManager.SHOW_ALL;
        this.scale.minWidth = this.config.minWidth;
        this.scale.minHeight = this.config.minHeight;
        this.scale.maxWidth = this.config.maxWidth;
        this.scale.maxHeight = this.config.maxHeight;
        this.scale.pageAlignHorizontally = this.config.pageAlignHorizontally;
        this.scale.pageAlignVertically = this.config.pageAlignVertically;
        this.scale.setScreenSize(true);
        if (this.config.forceOrientation) {
          this.scale.forceOrientation(this.config.pageAlignHorizontally, this.config.pageAlignVertically);
          this.scale.enterIncorrectOrientation.add(this.enterIncorrectOrientation, this);
          this.scale.leaveIncorrectOrientation.add(this.leaveIncorrectOrientation, this);
        }
      }
      return this.state.start(this.config.assets, true, false);
    };

    Boot.prototype.gameResized = function(width, height) {};

    Boot.prototype.enterIncorrectOrientation = function() {
      this.orientated = false;
      return document.getElementById('orientation').style.display = 'block';
    };

    Boot.prototype.leaveIncorrectOrientation = function() {
      this.orientated = true;
      return document.getElementById('orientation').style.display = 'none';
    };

    return Boot;

  })(Phaser.State);

  li2.Config = Config = (function() {
    var DELIM_ARRAY, DELIM_STRING;

    DELIM_ARRAY = 'array/';

    DELIM_STRING = 'string/';

    Config.prototype.path = "";

    Config.prototype.name = "name";

    Config.prototype.title = '';

    Config.prototype.boot = "__boot";

    Config.prototype.assets = "__assets";

    Config.prototype.menu = "__menu";

    Config.prototype.debug = false;

    Config.prototype.locale = false;

    Config.prototype.transparent = true;

    Config.prototype.id = "";

    Config.prototype.renderer = Phaser.CANVAS;

    Config.prototype.width = 320;

    Config.prototype.height = 480;

    Config.prototype.minWidth = 320;

    Config.prototype.minHeight = 480;

    Config.prototype.maxWidth = 640;

    Config.prototype.maxHeight = 960;

    Config.prototype.pageAlignHorizontally = true;

    Config.prototype.pageAlignVertically = true;

    Config.prototype.forceOrientation = false;

    Config.prototype.orientation = '';

    Config.prototype.showSplash = false;

    Config.prototype.splashKey = 'splashScreen';

    Config.prototype.splashImg = '';

    Config.prototype.showPreloadBar = false;

    Config.prototype.preloadBarKey = 'preloadBar';

    Config.prototype.preloadBarImg = '';

    Config.prototype.preloadBgdKey = 'preloadBgd';

    Config.prototype.preloadBgdImg = '';

    Config.prototype.paths = null;

    Config.prototype.sections = null;

    Config.prototype.audio = null;

    Config.prototype.images = null;

    Config.prototype.sprites = null;

    Config.prototype.tilemaps = null;

    Config.prototype.levels = null;

    Config.prototype.strings = null;

    Config.prototype.arrays = null;

    Config.prototype.preferences = null;

    Config.prototype.extra = null;


    /*
     * Load configuration
     *
     * @param source  yaml configuration string
     * @param path    base asset path
     */

    function Config(source, path) {
      var raw;
      this.source = source;
      this.path = path != null ? path : '';
      this.xlate = __bind(this.xlate, this);
      this.setSection = __bind(this.setSection, this);
      this.paths = {};
      this.sections = {};
      this.audio = {};
      this.images = {};
      this.sprites = {};
      this.tilemaps = {};
      this.levels = {};
      this.strings = {};
      this.arrays = {};
      this.preferences = {};
      this.extra = {};
      if (this.path.length !== 0) {
        if (this.path[-1] !== '/') {
          this.path += '/';
        }
      }
      raw = YAML.parse(this.source);
      if (raw.boot != null) {
        this.boot = raw.boot;
      }
      if (raw.assets != null) {
        this.assets = raw.assets;
      }
      if (raw.menu != null) {
        this.menu = raw.menu;
      }
      if (raw.id != null) {
        this.id = raw.id;
      }
      this.showSplash = raw.showSplash;
      this.transparent = raw.transparent;
      this.locale = raw.locale;
      this.name = raw.name;
      this.title = raw.title;
      this.paths = raw.paths;
      this.width = raw.minWidth;
      this.height = raw.minHeight;
      this.minWidth = raw.minWidth;
      this.minHeight = raw.minHeight;
      this.maxWidth = raw.maxWidth;
      this.maxHeight = raw.maxHeight;
      this.pageAlignHorizontally = raw.pageAlignHorizontally;
      this.pageAlignVertically = raw.pageAlignVertically;
      this.forceOrientation = raw.forceOrientation;
      this.splashKey = raw.splashKey;
      this.splashImg = raw.splashImg;
      this.showPreloadBar = raw.showPreloadBar;
      this.preloadBarKey = raw.preloadBarKey;
      this.preloadBarImg = raw.preloadBarImg;
      this.preloadBgdKey = raw.preloadBgdKey;
      this.preloadBgdImg = raw.preloadBgdImg;
      this.sections = raw.sections;
      this.audio = raw.audio;
      this.images = raw.images;
      this.sprites = raw.sprites;
      this.tilemaps = raw.tilemaps;
      this.levels = raw.levels;
      this.strings = raw.strings;
      this.preferences = raw.preferences;
      this.extra = raw.extra;
    }


    /*
     * Load optional config sections, such as from res/values/strings.yaml
     */

    Config.prototype.setSection = function(name, source) {
      var e, key, str, values, _ref, _results;
      if (name === 'arrays') {
        try {
          _ref = YAML.parse(source);
          _results = [];
          for (key in _ref) {
            values = _ref[key];
            this.arrays[key] = [];
            _results.push((function() {
              var _i, _len, _results1;
              _results1 = [];
              for (_i = 0, _len = values.length; _i < _len; _i++) {
                str = values[_i];
                _results1.push(this.arrays[key].push(this.xlate(str)));
              }
              return _results1;
            }).call(this));
          }
          return _results;
        } catch (_error) {
          e = _error;
        }
      } else {
        try {
          return this[name] = YAML.parse(source);
        } catch (_error) {
          e = _error;
        }
      }
    };


    /*
     * Translate string value
     */

    Config.prototype.xlate = function(value) {
      if ('string' === typeof value) {
        if (value.indexof(DELIM_STRING) === 0) {
          return this.strings[values.replace(DELIM_STRING, '')];
        } else if (value.indexOf(DELIM_ARRAY) === 0) {
          return this.strings[values.replace(DELIM_ARRAY, '')];
        } else {
          return value;
        }
      } else {
        return value;
      }
    };

    return Config;

  })();

  li2.Dilithium = Dilithium = (function(_super) {
    __extends(Dilithium, _super);

    Dilithium.prototype.config = null;

    Dilithium.prototype.game = null;


    /*
     * Static Using ...
     *
     * @param path     path to config file root
     * @paran complete completer function
     */

    Dilithium.using = function(path, complete) {
      var httpConfig;
      httpConfig = new XMLHttpRequest();
      httpConfig.onreadystatechange = function() {
        var config, done, flag, i, name, section, sections, src, _i, _j, _k, _len, _len1, _ref, _ref1;
        if (httpConfig.readyState === 4 && httpConfig.status === 200) {
          config = new Config(httpConfig.responseText, path);
          sections = [];
          if (config.sections.strings != null) {
            sections.push({
              name: 'strings',
              src: config.sections.strings,
              http: new XMLHttpRequest()
            });
            if (config.locale) {
              sections.push({
                name: 'strings',
                src: config.sections.strings.replace('.yaml', "-" + window.navigator.language + ".yaml"),
                http: new XMLHttpRequest()
              });
            }
          }
          _ref = config.sections;
          for (name in _ref) {
            src = _ref[name];
            if (name !== 'strings') {
              sections.push({
                name: name,
                src: src,
                http: new XMLHttpRequest()
              });
            }
          }
          if (sections.length === 0) {
            return complete(config);
          }
          flag = 0;
          done = 0;
          for (i = _i = 0, _ref1 = sections.length; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; i = 0 <= _ref1 ? ++_i : --_i) {
            done += Math.pow(2, i);
          }
          for (_j = 0, _len = sections.length; _j < _len; _j++) {
            section = sections[_j];
            section.http.onreadystatechange = function() {
              var check, m, _k, _l, _len1, _ref2, _ref3;
              for (check = _k = 0, _ref2 = sections.length; 0 <= _ref2 ? _k < _ref2 : _k > _ref2; check = 0 <= _ref2 ? ++_k : --_k) {
                if (sections[check].http.readyState === 4 && ((_ref3 = sections[check].http.status) === 200 || _ref3 === 404)) {
                  flag |= Math.pow(2, check);
                }
              }
              if (flag === done) {
                for (_l = 0, _len1 = sections.length; _l < _len1; _l++) {
                  m = sections[_l];
                  if (m.http.status === 200) {
                    config.setSection(m.name, m.http.responseText);
                  }
                }
                complete(config);
              }
            };
          }
          for (_k = 0, _len1 = sections.length; _k < _len1; _k++) {
            section = sections[_k];
            section.http.open('GET', "" + path + "/" + section.src, true);
            section.http.send();
          }
        } else if (httpConfig.readyState === 4 && httpConfig.status !== 200) {
          config = new li2.Config('', path);
          complete(config);
        }
      };
      httpConfig.open('GET', "" + path + "/config.yaml", true);
      httpConfig.send();
    };


    /*
     * == New Game ==
     *   * Set the screen dimensions
     *   * Configure the game states
     *   * Start the game
     *
     * returns this
     */

    function Dilithium(config) {
      this.config = config;
      console.log("Dilithium initialized");
      this.game = new Phaser.Game(this.config.width, this.config.height, this.config.renderer, this.config.id, this);
    }


    /*
     * Create the game states and start the game
     */

    Dilithium.prototype.create = function() {
      this.game.state.add(this.config.boot, new li2.Boot(this.config));
      this.game.state.add(this.config.assets, new li2.Assets(this.config));
      this.game.state.add(this.config.menu, this.levels());
      return this.game.state.start(this.config.boot);
    };


    /*
     * Override to define game states
     */

    Dilithium.prototype.levels = function() {};

    return Dilithium;

  })(Phaser.State);

  li2.Template = Template = (function() {
    Template.prototype.template = '';

    Template.prototype._template = null;

    function Template(template) {
      parse(template);
    }

    Template.prototype.parse = function(template) {
      this.template = template;
      this._template = Liquid.Template.parse(template);
    };

    Template.prototype.render = function(variables) {
      return this._template.render(variables);
    };

    return Template;

  })();

  if (typeof module !== "undefined" && module !== null) {
    module.exports = li2;
  } else {
    window.li2 = li2;
  }

}).call(this);

//# sourceMappingURL=dilithium.js.map
