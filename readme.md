# ==&lt; dilithium: li2 &gt;==

Use yaml to configure play_phaser assets.

Liquid based project scaffold generator.

## Quickstart

### Install

```bash
$ sudo npm install dilithium -g
```

### Create a new Dart project

```bash
$ li2 create DemoApp
$ cd demoapp
$ pub build
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

#### Framework Classes

* Li2Assets     - load assets listed in config.yaml
* Li2Boot       - set device params, load splash screen
* Li2Button     - Button+Text component
* Li2Config     - Wraps the config.yaml
* Li2State      - Add dilithium methods to the State class
* Li2Template   - Wraps the embedded Liquid Template engine

### Usage

    Usage:
      li2 create PATH [-t name | <path>]
    
    Options:
      -h  [--help]        # display this message
      -t  [--template]    # new project template, defaults to 'default'
      -v  [--version]     # display version
      -a  [--author]      # set author
      -d  [--description] # set description
      -l  [--license]     # set license text
      -w  [--webpage]     # set home page



### What Next?

Copy /usr/lib/node_modules/dilithium/templates/default somewhere, and make your own template.
Use flag --template path/to/template to specify your custom template.

Templates use Liquid syntax. The following variables are available:

* project.name          
* project.libname
* project.description
* project.author
* project.homepage
* project.license
  
Templates can be used in path names. For example, in a project named 'Demo', a template file named {{project.name}}.dart is transformed into Demo.dart

