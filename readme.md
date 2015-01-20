# ==< dilithium: li2 >==

## dilithium
Dart Library - use yaml to configure play_phaser assets.

#### Dart Framework Classes

* Dilithium     - Game application class
* Assets        - * load assets listed in config.yaml
* Boot          - * set device params, load splash screen
* Config        - ** Wraps the config.yaml
* Template      - Wraps the embedded Liquid Template engine

    * = Auto invoked by dilithium
    ** = Populated by dilithium

## li2
A project template generator using Liquid templates.
Li2 was created to generate dilithium projects
but could be used for many other programming languages.

Think jekyll, but for code.

Currently, there are 5 templates:

* default - a port of phaser_tutorial_02 to dart
* dartemis - a port of phaser_tutorial_02 using dartemis
* dilithium - an empty scaffold using dilithium
* match3 - demo game using dilithium
* coffee/pirate - demo in coffee-script


## Quickstart

### Install

```bash
$ sudo npm install dilithium -g
```

### Create a new Dart project

```bash
$ li2 create game -t default
$ cd game
$ pub get
$ pub serve
```

Inject yaml config into application:
```dart
void main() {

  Dilithium
  .using("packages/appname/res")
  .then((config) => new App(config));

}

class App extends Dilithium {

  App(config) : super(config);

}

```


### Usage


    Usage:
      li2 create PATH [project -t name | <path>]
      li2 set --option "value"
      li2 set --source +.java --source -.dart

      set values are saved in ~/.dilithium.json

    Options:
      -h  [--help]        # display this message
      -t  [--template]    # new project template, defaults to 'default'
      -v  [--version]     # display version
      -a  [--author]      # set author
      -c  [--copyright]   # set copyright
      -d  [--description] # set description
      -l  [--license]     # set license text
      -s  [--source]      # set filetype to be source template
      -w  [--webpage]     # set home page



### What Next?

Copy /usr/lib/node_modules/dilithium/templates/default somewhere, and make your own template.
Use flag --template path/to/template to specify your custom template.

Templates use Liquid syntax. The following variables are available:

* project.name          
* project.libname
* project.author
* project.copyright
* project.description
* project.homepage
* project.license
* project.source

Templates can be used in path names. For example, in a project named 'Demo', a template file named {{project.name}}.dart is transformed into Demo.dart

