###
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

###
'use strict'
li2 = {}

#+--------------------------------------------------------------------+
#| assets.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+

#
# Load the game assets
#
#
li2.Assets = class Assets extends Phaser.State

  preloadBar: null
  preloadBgd: null
  config: {}

  # set the configuration
  constructor:(@config) ->

  # preload game assets
  preload: () ->

    console.log "Class Assets initializing"

    # first, display the splash
    if @config.showSplash
      @load.setPreloadSprite(@add.sprite(0, 0, @config.splashKey))

    # display loading progress bar
    if @config.showPreloadBar
      preloadBgd = @add.sprite(config.width*0.5, config.height*0.5, @config.preloadBgdKey)
      preloadBgd.anchor.setTo(0.5, 0.5)
      preloadBar = @add.sprite(config.width*0.5, config.height*0.75, @config.preloadBarKey)
      preloadBar.anchor.setTo(0.5, 0.5)
      @load.setPreloadSprite(preloadBar)

    # load audio assets
    if @config.audio
      for k, v of @config.audio
        @load.audio(k, @config.path+v)

    # load image assets
    if @config.images
      for k, v of @config.images
        @load.image(k, @config.path+v)

    # load tilemap level assets
    if @config.tilemaps
      for k, level of @config.tilemaps
        levelName = level.options.map
        @load.tilemap(levelName, @config.path+"levels/#{levelName.json}", null, Phaser.Tilemap.TILED_JSON)

    # load spritesheet assets
    if @config.sprites
      for key, sprite of @config.sprites 
        if 'string' is typeof sprite.file
          @load.spritesheet(key, @config.path+sprite.file, sprite.width, sprite.height)
        else
          if sprite['selected'] is true
            @load.spritesheet(key, @config.path+sprite.file[sprite.selected], sprite.width, sprite.height)
          sprite.file.forEach (file, ix) =>
            @load.spritesheet("#{key}[#{ix}]", @config.path+file, sprite.width, sprite.height)
        
    return


  create: () ->
    @state.start @config.menu, true, false

#+--------------------------------------------------------------------+
#| boot.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+

#
# == Initialize ==
#
#   * Start loading the the splash screen image
#   * Configure the game engine to the environment
#
li2.Boot = class Boot extends Phaser.State

  orientated: false
  config: {}

  # set the configuration
  constructor:(@config) ->
#    console.log "Class Li2Boot initialized"


  # preload splash assets
  preload: () ->

    if @config.splashKey isnt ''
      @load.image @config.splashKey, @config.path+@config.splashImg
    if @config.preloadBarKey isnt ''
      @load.image @config.preloadBarKey, @config.path+@config.preloadBarImg
      @load.image @config.preloadBgdKey, @config.path+@config.preloadBgdImg


  # Set the device characteristics
  create: () ->

    @input.maxPointers = 1
    @stage.disableVisibilityChange = true

    if @game.device.desktop
      @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
      @scale.minWidth = @config.minWidth
      @scale.minHeight = @config.minHeight
      @scale.maxWidth = @config.maxWidth
      @scale.maxHeight = @config.maxHeight
      @scale.pageAlignHorizontally = @config.pageAlignHorizontally
      @scale.pageAlignVertically = @config.pageAlignVertically
      @scale.setScreenSize true
    
    else
      @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
      @scale.minWidth = @config.minWidth
      @scale.minHeight = @config.minHeight
      @scale.maxWidth = @config.maxWidth
      @scale.maxHeight = @config.maxHeight
      @scale.pageAlignHorizontally = @config.pageAlignHorizontally
      @scale.pageAlignVertically = @config.pageAlignVertically
      @scale.setScreenSize true

      if @config.forceOrientation
        @scale.forceOrientation(@config.pageAlignHorizontally, @config.pageAlignVertically)
        @scale.enterIncorrectOrientation.add @enterIncorrectOrientation, @
        @scale.leaveIncorrectOrientation.add @leaveIncorrectOrientation, @

    # Load the remaining assets
    @state.start @config.assets, true, false

  gameResized: (width, height) ->


  enterIncorrectOrientation: () ->

    @orientated = false
    document.getElementById('orientation').style.display = 'block'

  leaveIncorrectOrientation: () ->

    @orientated = true
    document.getElementById('orientation').style.display = 'none'


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

#+--------------------------------------------------------------------+
#| dilithium.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+
li2.Dilithium = class Dilithium extends Phaser.State

  config  : null
  game    : null


  ###
  # Static Using ...
  #
  # @param path     path to config file root
  # @paran complete completer function
  ###
  @using:(path, complete) ->

    httpConfig = new XMLHttpRequest()
    httpConfig.onreadystatechange = ->
      if httpConfig.readyState is 4 and httpConfig.status is 200

        config = new Config(httpConfig.responseText, path)
        #
        # Extra Config Sections?
        #
        sections = []

        # process strings first
        if config.sections.strings?
          sections.push
            name  : 'strings'
            src   : config.sections.strings
            http  : new XMLHttpRequest()
          # do we get any locale settings?
          if config.locale
            sections.push
              name  : 'strings'
              src   : config.sections.strings.replace('.yaml', "-" + window.navigator.language + ".yaml")
              http  : new XMLHttpRequest()

        # then the rest
        for name, src of config.sections
          if name isnt 'strings'
            sections.push
              name  : name
              src   : src
              http  : new XMLHttpRequest()

        return complete(config) if sections.length is 0

        flag = 0 # how to tell
        done = 0 # when we are done
        done += Math.pow(2,i) for i in [0...sections.length]

        for section in sections
          section.http.onreadystatechange = ->

            # check if all are loaded
            for check in [0...sections.length]
              if sections[check].http.readyState is 4 and sections[check].http.status in [200, 404]
                flag |= Math.pow(2, check)

            if flag is done
              # finish up the config and start the game
              for m in sections
                config.setSection m.name, m.http.responseText if m.http.status is 200
              complete(config)
              return

        for section in sections
          section.http.open 'GET',"#{path}/#{section.src}", true
          section.http.send()
        return


      else if httpConfig.readyState is 4 and httpConfig.status isnt 200

        # no configuration file found,
        # start with default config values
        config = new li2.Config('', path)
        complete(config)
        return

    #
    # load the main config file
    #
    httpConfig.open 'GET', "#{path}/config.yaml", true
    httpConfig.send()
    return




  ###
  # == New Game ==
  #   * Set the screen dimensions
  #   * Configure the game states
  #   * Start the game
  #
  # returns this
  ###
  constructor:(@config) ->
    console.log "Dilithium initialized"
    @game = new Phaser.Game(@config.width, @config.height, @config.renderer, @config.id, this)

  ###
  # Create the game states and start the game
  ###
  create: ->
    @game.state.add @config.boot, new li2.Boot(@config)
    @game.state.add @config.assets, new li2.Assets(@config)
    @game.state.add @config.menu, @levels()
    @game.state.start @config.boot

  ###
  # Override to define game states
  ###
  levels: ->
#+--------------------------------------------------------------------+
#| template.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the GPLv3 License
#|
#+--------------------------------------------------------------------+
#
# == Initialize ==
#
#   * Start loading the the splash screen image
#   * Configure the game engine to the environment
#
li2.Template = class Template

  template: ''
  _template: null

  constructor:(template) ->
    parse template

  parse:(template) ->
    @template = template
    @_template = Liquid.Template.parse(template)
    return

  render:(variables) ->
    @_template.render(variables)



if module?
  module.exports = li2
else
  window.li2 = li2