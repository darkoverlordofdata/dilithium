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

#
# sources - list of file extensions treated as templates
#
sources = ['.html', '.xml', '.md', '.markdown', '.yaml', '.dart', '.li2', '.gitignore', '.css']

#
# variables - table of variables to replace in templates
#
variables =
  name          : ""
  libname       : ""
  description   : ""
  author        : ""
  homepage      : ""
  license       : "MIT License"
  template      : "default"

#
# plugins - table of liquid plugins installed from npm
#
plugins = {}

ucfirst = (s) -> s.charAt(0).toUpperCase() + s.substr(1)

module.exports =
#
# create a new project scaffold in cwd
#
# @param  [String]  appname app to create
# @param  [Array]   remaining arguments
# @return none
#
  run: (name, args...) ->

    variables.name = ucfirst(name.replace(/\s/g, ""))
    variables.libname = name.replace(/\s/g, "").toLocaleLowerCase()
    variables.description = name

    if args.length>0
      while (option = args.shift())?
        switch option

          when '-t', '--template'     then variables.template     = args.shift()
          when '-l', '--license'      then variables.license      = args.shift()
          when '-a', '--author'       then variables.author       = args.shift()
          when '-w', '--webpage'      then variables.homepage     = args.shift()
          when '-d', '--description'  then variables.description  = args.shift()

          else throw "ERR: Invalid option #{option}"

    liquidInitialization exports
    newpath = path.resolve(process.cwd(), variables.libname)
    tmppath = path.resolve(__dirname, "../../templates", variables.template)
    copydir tmppath, newpath
    console.log "Created #{variables.name} at #{newpath} from #{tmppath}..."

#
# recursively copy and transform template folders
#
copydir = (tmppath, newpath) ->

  console.log newpath
  #
  # generate output
  #
  fs.mkdirSync newpath unless fs.existsSync(newpath)

  for tmpname in fs.readdirSync(tmppath)

    newname = Liquid.Template.parse(tmpname).render(project: variables)

    tmp_file = path.resolve(tmppath, tmpname)
    new_file = path.resolve(newpath, newname)

    if fs.statSync(tmp_file).isDirectory()

      copydir tmp_file, new_file

    else

      if path.extname(tmp_file) in sources

        buf = String(fs.readFileSync(tmp_file))
        buf = Liquid.Template.parse(buf).render(project: variables)
        fs.writeFileSync new_file, buf

      else

        bin = fs.createWriteStream(new_file)
        bin.write fs.readFileSync(tmp_file)
        bin.end()


#
# Initialize Liquid
#
liquidInitialization = (ctx) ->
  #
  # Template include folder
  #
  Liquid.Template.fileSystem = new LocalFileSystem(path.resolve(__dirname, "/includes"))

  #
  # Custom Filters
  #
  Liquid.Template.registerFilter require(path.resolve(__dirname, "filters.coffee"))

  #
  # Custom Tags
  #
  for tag_name in fs.readdirSync(path.resolve(__dirname, "/tags"))
    require(path.resolve(__dirname, "/tags/", tag_name))(ctx)

  #
  # Plugins
  #
  require(plugin)(ctx) for plugin in plugins
  if fs.existsSync(path.resolve(__dirname, "/plugins"))
    for plugin in fs.readdirSync(path.resolve(__dirname, "/plugins"))
      require(path.resolve(__dirname, "/plugins/", plugin))(ctx)

