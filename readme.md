
           ___ ___ __  __    _               
      ____/ (_) (_) /_/ /_  (_)_  ______ ___ 
     / __  / / / / __/ __ \/ / / / / __ `__ \
    / /_/ / / / / /_/ / / / / /_/ / / / / / /
    \__,_/_/_/_/\__/_/ /_/_/\__,_/_/ /_/ /_/ 
                                             
                                                                      
==&lt; dilithium &gt;==

'Cause Every Phaser Needs A Warp Core'

Manage phaser assets in dart with yaml configuration file.
Integrated with project scaffold generator.
Uses Liquid templates to generate project files.



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
  .then((config) => new Game(config));

}
```


## Install

```bash
$ sudo npm install dilithium -g

```


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




