#+--------------------------------------------------------------------+
#| config.coffee
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

li2.Config = class Config


  DELIM_ARRAY = 'array/'
  DELIM_STRING = 'string/'

  path            : ""
  name            : "name"
  boot            : "__boot"
  assets          : "__assets"
  menu            : "__menu"
  debug           : false
  locale          : false
  transparent     : true

  id              : ""
  renderer        : Phaser.CANVAS # Force Canvas for Mobile
  width           : 320
  height          : 480
  minWidth        : 320
  minHeight       : 480
  maxWidth        : 640
  maxHeight       : 960
  pageAlignHorizontally : true
  pageAlignVertically   : true
  forceOrientation      : false

  orientation     : ''
  showSplash      : false
  splashKey       : 'splashScreen'
  splashImg       : ''

  showPreloadBar  : false
  preloadBarKey   : 'preloadBar'
  preloadBarImg   : ''
  preloadBgdKey   : 'preloadBgd'
  preloadBgdImg   : ''

  paths           : null
  sections        : null
  audio           : null
  images          : null
  sprites         : null
  tilemaps        : null
  levels          : null
  strings         : null
  arrays          : null
  preferences     : null
  extra           : null

  ###
  # Load configuration
  #
  # @param source  yaml configuration string
  # @param path    base asset path
  ###
  constructor:(@source, @path = '') ->

#    console.log "Class Li2Config initialized"

    @paths = {}
    @sections = {}
    @audio = {}
    @images = {}
    @sprites = {}
    @tilemaps = {}
    @levels = {}
    @strings = {}
    @arrays = {}
    @preferences = {}
    @extra = {}

    unless @path.length is 0
      @path += '/' unless @path[-1] is '/'

    raw = YAML.parse(@source)

    @boot = raw.boot if raw.boot?
    @assets = raw.assets if raw.assets?
    @menu = raw.menu if raw.menu?
    @id = raw.id if raw.id?
    @showSplash = raw.showSplash
    @transparent = raw.transparent
    @locale = raw.locale
    @name = raw.name
    @paths = raw.paths
    @width = raw.minWidth
    @height = raw.minHeight
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

    @sections = raw.sections
    @audio = raw.audio
    @images = raw.images
    @sprites = raw.sprites
    @tilemaps = raw.tilemaps
    @levels = raw.levels
    @strings = raw.preferences
    @extra = raw.extra


  ###
  # Load optional config sections, such as from res/values/strings.yaml
  ###
  setSection: (name, source) =>

    if name is 'arrays'
      try
        for key, values of YAML.parse(source)
          @arrays[key] = []
          for str in values
            @arrays[key].push @xlate(str)
      catch e
    else
      try
        @[name] = YAML.parse(source)
      catch e

  ###
  # Translate string value
  ###
  xlate:(value) =>
    if 'string' is typeof value
      if value.indexof(DELIM_STRING) is 0
        @strings[values.replace(DELIM_STRING, '')]
      else if value.indexOf(DELIM_ARRAY) is 0
        @strings[values.replace(DELIM_ARRAY, '')]
      else value
    else value
