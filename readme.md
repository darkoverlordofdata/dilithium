
           ___ ___ __  __    _               
      ____/ (_) (_) /_/ /_  (_)_  ______ ___ 
     / __  / / / / __/ __ \/ / / / / __ `__ \
    / /_/ / / / / /_/ / / / / /_/ / / / / / /
    \__,_/_/_/_/\__/_/ /_/_/\__,_/_/ /_/ /_/ 
                                             
                                                                      
==&lt; dilithium &gt;==

'Cause Every Phaser Needs A Warp Core'

# Quickstart

## Install

```bash
$ sudo npm install dilithium -g

```

### dart project scaffold generator

Use Liquid templates to generate projects

    Usage:
      li2 create PATH [-t name | <path>]
      cd PATH
      pub build
    
    Options:
      -h  [--help]        # display this message
      -t  [--template]    # new project template, defaults to 'default'
      -v  [--version]     # display version
      -a  [--author]      # set author
      -d  [--description] # set description
      -l  [--license]     # set license text
      -w  [--webpage]     # set home page




### manage phaser assets with yaml configuration file

```dart
void main() {

  Dilithium
  .using("packages/appname")
  .then((config) => new Game(config));

}

```

