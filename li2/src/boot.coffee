#+--------------------------------------------------------------------+
#| boot.coffee
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

