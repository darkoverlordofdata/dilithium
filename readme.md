# ==&lt; dilithium: li2 &gt;==

Use yaml to configure play_phaser assets.
Integrated project scaffold generator with Liquid templates.

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
  .using("packages/appname")
  .then((config) => new App(config));

}

class App extends Dilithium {

  App(config) : super(config);

}

```

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
  
Templates can be used in path names. For example:

    In a project named 'Demo', a template file named {{project.name}}.dart is transformed into Demo.dart

