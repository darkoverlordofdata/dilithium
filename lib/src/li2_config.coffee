#+--------------------------------------------------------------------+
#| Li2Config.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+
lib = require('../../lib')
yaml = require('js-yaml')

class lib.Li2Config


  DELIM_ARRAY = 'array/'
  DELIM_STRING = 'string/'

  path: ""
  name: "name"
  boot: "Li2Boot"
  assets: "Li2Assets"
  menu: "Li2Menu"
  debug: false

  renderer: Phaser.CANVAS # Force Canvas for Mobile
  width: 320
  height: 480
  minWidth: 320
  minHeight: 480
  maxWidth: 640
  maxHeight: 960
  pageAlignHorizontally: true
  pageAlignVertically: true
  forceOrientation: false

  splashKey: ''
  splashImg: ''

  showPreloadBar: false
  preloadBarKey: ''
  preloadBarImg: ''
  preloadBgdKey: ''
  preloadBgdImg: ''

  locale: false
  sections: {}
  audio: {}
  images: {}
  sprites: {}
  tilemaps: {}
  levels: {}
  strings: {}
  arrays: {}
  preferences: {}

  ###
  # Load configuration
  #
  # @param source  yaml configuration string
  # @param path    base asset path
  ###
  constructor:(@source, @path = '') ->

#    console.log "Class Li2Config initialized"

    unless @path.length is 0
      @path += '/' unless @path[-1] is '/'

    raw = yaml.load(@source)
    @locale = raw.locale
    @name = raw.name
    @sections = raw.sections
    @minWidth = raw.minWidth
    @minHeight = raw.minHeight
    @maxWidth = raw.maxWidth
    @maxHeight = raw.maxHeight
    @pageAlignHorizontally = raw.pageAlignHorizontally
    @pageAlignVertically = raw.pageAlignVertically
    @forceOrientation = raw.forceOrientation
    @splashKey = raw.splashKey
    @splashImg = raw.splashImg
    @showPreloadBar = raw.showPreloadBar
    @preloadBarKey = raw.preloadBarKey
    @preloadBarImg = raw.preloadBarImg
    @preloadBgdKey = raw.preloadBgdKey
    @preloadBgdImg = raw.preloadBgdImg
    @audio = raw.audio
    @images = raw.images
    @sprites = raw.sprites
    @levels = raw.levels
    @extra = raw.extra
    @strings = raw.strings


  ###
  # Load optional config sections, such as from res/values/strings.yaml
  ###
  setSection: (name, source) ->

    if name is 'arrays'
      try
        for key, values of yaml.load(source)
          @arrays[key] = []
          for str in values
            @arrays[key].push @xlate(str)
      catch e
    else
      try
        @[name] = yaml.load(source)
      catch e

  ###
  # Translate string value
  ###
  xlate:(value) ->
    if 'string' is typeof value
      if value.indexof(DELIM_STRING) is 0
        @strings[values.replace(DELIM_STRING, '')]
      else if value.indexOf(DELIM_ARRAY) is 0
        @strings[values.replace(DELIM_ARRAY, '')]
      else value
    else value
