#+--------------------------------------------------------------------+
#| create.coffee
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
# Create a new app folder:
#
#   li2 create <appname>
#
#
fs = require('fs')
path = require('path')
Liquid = require('huginn-liquid')
LocalFileSystem = require('./classes/LocalFileSystem')

sources = ['.html', '.xml', '.md', '.markdown', '.yaml', '.dart', '.li2', '.gitignore', '.css']

vars =
  name          : ""
  libname       : ""
  license       : "MIT License"
  description   : ""
  author        : ""
  homepage      : ""
  template      : "default"

module.exports = create =
#
# create a new project scaffold in cwd
#
# @param  [String]  appname app to create
# @return none
#
  run: (name, args...) ->

    #
    #   Initialize Liquid
    #
    Liquid.Template.fileSystem = new LocalFileSystem(path.resolve(__dirname, "/includes"))
    Liquid.Template.registerFilter require(path.resolve(__dirname, "filters.coffee"))

    vars.name = name.replace(/\s/g, "")
    vars.libname = name.replace(/\s/g, "").toLocaleLowerCase()
    vars.description = name

    newpath = path.resolve(process.cwd(), vars.libname)

    if args.length>0

      while (option = args.shift())?

        switch option

          when '-t', '--template'
            vars.template = args.shift()

          when '-l', '--license'
            vars.license = args.shift()

          when '-a', '--author'
            vars.author = args.shift()

          when '-w', '--webpage'
            vars.homepage = args.shift()

          when '-d', '--description'
            vars.description = args.shift()

          else
            throw "ERR: Invalid option #{option}"

    tmppath = path.resolve(__dirname, "../../templates", vars.template)

    console.log "Creating #{vars.name} at #{newpath} from #{tmppath}..."

    create.copydir tmppath, newpath

  copydir: (tmppath, newpath) ->

    console.log newpath
    #
    # generate output
    #
    fs.mkdirSync newpath unless fs.existsSync(newpath)

    for tmpname in fs.readdirSync(tmppath)
      stats = fs.statSync(path.resolve(tmppath, tmpname))
      if stats.isDirectory()
        create.copydir path.resolve(tmppath, tmpname), path.resolve(newpath, tmpname)

      else
        newname = Liquid.Template.parse(tmpname).render(project: vars)

        #console.log "copy "+path.resolve(tmppath, tmpname)+" to "+path.resolve(newpath, newname)

        if path.extname(tmpname) in sources

          buf = String(fs.readFileSync(path.resolve(tmppath, tmpname)))
          buf = Liquid.Template.parse(buf).render(project: vars)
          fs.writeFileSync path.resolve(newpath, newname), buf

        else

          bin = fs.createWriteStream(path.resolve(newpath, newname))
          bin.write fs.readFileSync(path.resolve(tmppath, tmpname))
          bin.end()



