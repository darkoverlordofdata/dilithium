#+--------------------------------------------------------------------+
#| Dilithium.coffee
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
li2 = require('../../lib')

class li2.Dilithium extends Phaser.State

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

        config = new li2.Li2Config(httpConfig.responseText, path)
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
        config = new li2.Li2Config('', path)
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
    @game.state.add @config.boot,  new li2.Li2Boot(@config)
    @game.state.add @config.assets,  new li2.Li2Assets(@config)
    @game.state.add @config.menu, @levels()
    @game.state.start @config.boot

  ###
  # Override to define game states
  ###
  levels: ->