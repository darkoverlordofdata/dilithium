#+--------------------------------------------------------------------+
#| util.coffee
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
fs = require('fs')

#
# dilithium configuration file
#
dilithium_json = "#{process.env.HOME}/.dilithium.json"

#
# Utility
#
module.exports =

  #
  # return the config filename
  #
  configFile: () ->
    dilithium_json

  #
  # load config & defaults
  #
  variables: () ->

    variables = require("./.dilithium.json")
    dilithium = if fs.existsSync(dilithium_json) then require(dilithium_json) else {}
    for k, v of dilithium
      variables[k] = v

    return variables

  #
  # merge config with args
  #
  merge: (args, variables) ->

    if args.length>0
      while (option = args.shift())?
        switch option

          when '-a', '--author'       then variables.author       = args.shift()
          when '-c', '--copyright'    then variables.copyright    = args.shift()
          when '-d', '--description'  then variables.description  = args.shift()
          when '-l', '--license'      then variables.license      = args.shift()
          when '-t', '--template'     then variables.template     = args.shift()
          when '-w', '--webpage'      then variables.homepage     = args.shift()
          when '-s', '--source'

            ext = args.shift()
            switch ext[0]
              when '-'
                ext = ext[1..]
                ext = '.'+ext unless ext[0] is '.'
                ix = variables.source.indexOf(ext)
                variables.source.splice ix, 1 unless ix is -1
              when '+'
                ext = ext[1..]
                ext = '.'+ext unless ext[0] is '.'
                variables.source.push ext if variables.source.indexOf(ext) is -1
              else
                ext = '.'+ext unless ext[0] is '.'
                variables.source.push ext if variables.source.indexOf(ext) is -1


          else throw "ERR: Invalid option #{option}"

    return variables
