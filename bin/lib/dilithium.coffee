#+--------------------------------------------------------------------+
#| dilithium
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
##
# dilithium command dispatch
#

Object.defineProperties module.exports,

  create: # create a new project
    get: ->
      require('./create.coffee').run

  set: # set dilithium valies
    get: ->
      require('./set.coffee').run
