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
Liquid = require('liquid.coffee')
util = require('./util')
LocalFileSystem = require('./classes/LocalFileSystem')

#
# executable - list of file extension executables for plugins
#
executable = ['.coffee', '.js']

sources = ['.html', '.xml', '.md', '.markdown', '.js', '.dart', '.coffee', '.yaml']
variables = {}


#
# plugins - table of liquid plugins installed from npm
#
plugins = {}

module.exports =
#
# create a new project scaffold in cwd
#
# @param  [String]  appname app to create
# @param  [Array]   remaining arguments
# @return none
#
  run: (name, args...) ->

    #
    # variables - table of variables to replace in templates
    #
    variables = util.variables()
    variables.name = pascalCase(name)
    variables.libname = snakeCase(name)
    variables.description = name
    variables = util.merge(args, variables)

    liquidInitialization exports
    newpath = path.resolve(process.cwd(), variables.libname)
    tmppath = if fs.existsSync(variables.template) then variables.template
    else path.resolve(__dirname, "../../templates", variables.template)
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

    tmp_file = path.join(tmppath, tmpname)
    new_file = path.join(newpath, newname)

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
  Liquid.Template.fileSystem = new LocalFileSystem(path.join(__dirname, "/includes"))

  #
  # Custom Filters
  #
  Liquid.Template.registerFilter require(path.join(__dirname, "filters.coffee"))

  #
  # Custom Tags
  #
  for tag_name in fs.readdirSync(path.join(__dirname, "/tags"))
    if path.extname(tag_name) in executable
      require(path.join(__dirname, "/tags/", tag_name))(ctx)

  #
  # Plugins
  #
  require(plugin)(ctx) for plugin in plugins
  if fs.existsSync(path.join(__dirname, "/plugins"))
    for plugin in fs.readdirSync(path.join(__dirname, "/plugins"))
      if path.extname(tag_name) in executable
        require(path.join(__dirname, "/plugins/", plugin))(ctx)


#
# Project Name  => ProjectName
#
pascalCase = (str) ->

  res = ''
  for s in str.split(/\s+/)
    res += (s.charAt(0).toUpperCase() + s.substr(1))
  return res

#
# Project Name  => project_name
#
snakeCase = (str) -> str.replace(/\s+/g, '_').toLowerCase()