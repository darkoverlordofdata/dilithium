#+--------------------------------------------------------------------+
#| set.coffee
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
# Set dilithium default project values
#
#   li2 set --option "value"
#
#  -a  [--author]      # set author
#  -c  [--copyright]   # set copyright
#  -d  [--description] # set description
#  -l  [--license]     # set license text
#  -s  [--source]      # set filetype to be source template
#  -t  [--template]    # set new project template, defaults to 'default'
#  -w  [--webpage]     # set home page

#
#
fs = require('fs')
path = require('path')
util = require('./util')

module.exports =
#
# Set configuration values
#
# @param  [Array]   cli arguments
# @return none
#
  run: (args...) ->

    variables = util.merge(args, util.variables())
    text = JSON.stringify(variables)
    fs.writeFile util.configFile(), text, (err) ->
      if (err) then throw err
      console.log "dilithium options set."


