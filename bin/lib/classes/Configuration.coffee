#+--------------------------------------------------------------------+
#| Configuration.coffee
#+--------------------------------------------------------------------+
#| Copyright DarkOverlordOfData (c) 2013 - 2014
#+--------------------------------------------------------------------+
#|
#| This file is a part of Huginn
#|
#| Huginn is free software; you can copy, modify, and distribute
#| it under the terms of the MIT License
#|
#+--------------------------------------------------------------------+
#
#
# Load Huginn configuration
#
fs = require('fs')
path = require('path')
yaml = require('yaml-js')


module.exports = class Configuration

  #
  # @property [String] The site name
  #
  name: 'My Site'
  #
  # @property [String] The site description
  #
  description: 'This is My Site'
  #
  # @property [String] base url
  #
  url: 'http://localhost/'
  #
  # @property [String] the port to serve
  #
  port: 0xd16a
  #
  # @property [String] file system root of the site source
  #
  source: './source'
  #
  # @property [String] file system root of the site destination
  #
  destination: './gh-pages/mysite'
  #
  # @property [Array<String>] List of file sytem roots to serve
  #
  serve: ['./gh-pages']
  #
  # @property [Array<String>] List of exernal plugins
  #
  plugins: ['huginn-asset-bundler', 'huginn-tag-cloud']
  #
  # @property [Array<String>] List of markdown file extensions
  #
  markdown: ['.md', '.markdown']
  #
  # @property [Array<String>] List of templated file extensions
  #
  template: ['.html', '.xml', '.md', '.markdown']


  constructor: ($dev = true) ->

    $file = if $dev then 'config-dev.yml' else 'config.yml'
    $root = process.cwd()

    if fs.existsSync("#{$root}/#{$file}")
      $config = yaml.load(fs.readFileSync("#{$root}/#{$file}"))
    else
      throw "ERR: Huginn config file #{$file} not found"

    if not fs.existsSync($config.source)
      throw "ERR: Huginn source directory #{$config.source} not found"

    #
    # Copy settings to the configuration object
    #
    for $key, $value of $config
      if $key in ['template']
        @[$key] = [].concat(@[$key], $value)
      else
        @[$key] = $value
