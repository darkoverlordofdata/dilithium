#+--------------------------------------------------------------------+
#| create.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013 - 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of dilithium
#|
#| dilithium is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
# Create a new app folder:
#
#   li2 create <appname>
#
#
fs = require('fs')
path = require('path')
#templates = require('./templates')

module.exports =
#
# create a new project scaffold in cwd
#
# @param  [String]  appname app to create
# @return none
#
  run: (path, args...) ->

    template = 'default'
    project = path
    if args.length>0

      if args[0][0] isnt '-' then project = args.shift()

      while (option = args.shift())?

        switch option

          when '-t', '--template'
            template = args.shift()

          else
            throw "ERR: Invalid option #{option}"



    console.log "Creating #{project} at #{path} from #{template}..."
