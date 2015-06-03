#+--------------------------------------------------------------------+
#| assets.coffee
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
      preloadBgd = @add.sprite(@config.width*0.5, @config.height*0.5, @config.preloadBgdKey)
      preloadBgd.anchor.setTo(0.5, 0.5)
      preloadBar = @add.sprite(@config.width*0.5, @config.height*0.75, @config.preloadBarKey)
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
